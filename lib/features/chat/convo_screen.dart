import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/chat_model.dart';
import 'package:quickdrop_app/core/providers/chat_provider.dart';

class ConversationScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const ConversationScreen({
    super.key,
    required this.user,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  List<Map<String, dynamic>> messages = [];
  TextEditingController messageController = TextEditingController();

  void _sendMessage() async {
    if (messageController.text.isEmpty) return;
    
    // print("user id ${widget.user['uid']}");
    ChatModel message = ChatModel(
        receiverId: widget.user['uid'],
        senderId: FirebaseAuth.instance.currentUser!.uid,
        timestamp: DateTime.now().toString(),
        text: messageController.text,
        type: "text"
      );
    try {
      await Provider.of<ChatProvider>(context, listen: false)
          .addMessage(message);
      messageController.clear();
    } catch (e) {
      // print("Error sending message: $e");
      if (mounted) AppUtils.showError(context, "Failed to send message ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final chatId = getChatId(
        FirebaseAuth.instance.currentUser!.uid, widget.user['uid']);

    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: UserProfileCard(
            header: widget.user['displayName'],
            onPressed: () => print("user profile  Clicked"),
            photoUrl: widget.user['photoUrl'],
            headerFontSize: 14,
            subHeaderFontSize: 10,
            avatarSize: 18,
          ),
          backgroundColor: AppColors.barColor,
        ),
        body: Column(children: [
          Expanded(
            child: StreamBuilder(
              stream:  chatProvider.getMessages(chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading messages"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }
                final messages = snapshot.data  ?? [];
                return ListView.builder(
                  reverse: true,

                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId ==
                        FirebaseAuth.instance.currentUser?.uid;
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.blue : AppColors.lessImportant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                              color: isMe ? Colors.white : Colors.black),
                        ),
                      ),
                  );
                  },
                );
              },
            ) 
            ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                      controller: messageController,
                      onChanged: (text) {
                        // Handle text input
                        print("Text input: $text");
                      },
                      style: const TextStyle(
                        color: AppColors.lessImportant,
                        fontSize: 14,
                      ),
                      decoration: const InputDecoration(
                        // borderRadius: BorderRadius.all(Radius.circular(20)),

                        filled: true,
                        fillColor: AppColors.chatMessageInput,
                        hintText: 'message ...',
                        border: OutlineInputBorder(
                          // borderSide: BorderSide.none, // Removes visible border
                          borderRadius: BorderRadius.all(Radius.circular(
                              AppTheme.chatInputRadius)), // Adds border radius
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppTheme.chatInputRadius)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppTheme.chatInputRadius)),
                        ),
                      ),
                    )),
                    IconButton(
                      icon: const Icon(Icons.send, size: 36, color: AppColors.blue),
                      onPressed: _sendMessage,
                    )
              ]))
        ]));
  }
}

         