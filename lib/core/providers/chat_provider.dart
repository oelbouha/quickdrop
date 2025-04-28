import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/features/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickdrop_app/core/utils/delivery_status.dart';
import 'package:quickdrop_app/features/models/user_model.dart';
import 'package:provider/provider.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Map<String, UserData> _users = {};

  Future<void> addMessage(ChatModel message) async {
    if (message.receiverId == _auth.currentUser?.uid) {
      throw Exception(
          "Invalid sender ID: you cannot send message to your self");
    }
    final chatId = getChatId(message.senderId, message.receiverId);
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
    final messagesRef = chatRef.collection("messages").doc();

    try {
      await messagesRef.set(message.toMap());

      await chatRef.set({
        'participants': [message.senderId, message.receiverId],
        'lastMessage': message.text,
        'lastMessageSeen': message.seen,
        'timestamp': message.timestamp,
        'lastMessageTimestamp': message.timestamp,
        'lastMessageSender': message.senderId,
      }, SetOptions(merge: true));
      notifyListeners();
    } catch (e) {
      print('Error adding message: $e');
      rethrow;
    }
  }

  Future<void> markMessageAsSeen(String chatId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return Future.value();

      final doc = _firestore.collection('chats').doc(chatId);
      final snapshot = await doc.get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        if (data['lastMessageSender'] != userId) {
          // print("Sender is the same as  the current user");
          doc.update({
            'lastMessageSeen': true,
            // 'lastMessageTimestamp': DateTime.now().toString(),
          });
          notifyListeners();
        }
      }

      return _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('receiverId', isEqualTo: userId)
          .where('seen', isEqualTo: false)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.update({'seen': true});
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ChatModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> fetchUsersData(List<String> ids) async {
    for (final id in ids) {
      if (!_users.containsKey(id)) {
        final data =
            await FirebaseFirestore.instance.collection('users').doc(id).get();
        if (data.exists) {
          _users[id] = UserData.fromMap(data.data()!);
        }
      }
    }
  }

  Stream<List<Map<String, dynamic>>> getConversations() {
    // print("Fetching conversations");
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    // print("User ID: $userId");
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        // .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final conversations = snapshot.docs.map((doc) {
        final data = doc.data();
        final chatId = doc.id;
        final lastMessage = data['lastMessage'] ?? '';
        final lastMessageSender = data['lastMessageSender'] ?? '';
        final lastMessageSeen = data['lastMessageSeen'] ?? false;
        final lastMessageTimestamp = data['lastMessageTimestamp'] ?? '';
        final participants = List<String>.from(data['participants'] ?? []);
        return {
          'chatId': chatId,
          'lastMessage': lastMessage,
          'lastMessageSeen': lastMessageSeen,
          'lastMessageSender': lastMessageSender,
          'lastMessageTimestamp': lastMessageTimestamp,
          'participants': participants,
        };
      }).toList();

      // print("Conversations: $conversations");
      if (conversations.isEmpty) return [];

      // print("Fetching users data");

      final userIds = conversations
          .expand(
              (conversation) => conversation['participants'] as List<String>)
          .where((id) => id != userId)
          .toSet()
          .toList();

      // print("uasers length: ${userIds.length}");
      // print("User IDs: $userIds");

      if (userIds.isNotEmpty) {
        final userDocs = await Future.wait(
          userIds.map((id) => _firestore.collection('users').doc(id).get()),
        );
        for (var doc in userDocs) {
          if (doc.exists) {
            _users[doc.id] = UserData.fromMap(doc.data()!);
          }
        }
      }

      // print("Fetched users: ${_users.length}");

      return conversations.map((conversation) {
        final userId = conversation['participants']
            .firstWhere((id) => id != _auth.currentUser?.uid, orElse: () => '');
        final user = _users[userId];
        return {
          'chatId': conversation['chatId'],
          'lastMessage': conversation['lastMessage'],
          'lastMessageSeen': conversation['lastMessageSeen'],
          'lastMessageSender': conversation['lastMessageSender'],
          'lastMessageTimestamp': conversation['lastMessageTimestamp'],
          'userName': user?.displayName,
          'photoUrl': user?.photoUrl,
          'userId': user?.uid,
        };
      }).toList();
    });
  }
}

String getChatId(String user1, String user2) {
  return user1.hashCode <= user2.hashCode
      ? '${user1}_$user2'
      : '${user2}_$user1';
}

extension on ChatModel {
  ChatModel copyWith({
    String? id,
    String? receiverId,
    String? senderId,
    String? timestamp,
    String? type,
    String? text,
    bool seen = false,
  }) {
    return ChatModel(
        id: id ?? this.id,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
        timestamp: timestamp ?? this.timestamp,
        type: type ?? this.type,
        text: text ?? this.text,
        seen: seen);
  }
}
