import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/chat_model.dart';
import 'package:quickdrop_app/core/providers/negotiation_provider.dart';
import 'package:quickdrop_app/features/models/negotiation_model.dart';

class NegotiationScreen extends StatefulWidget {
  final UserData user;
  final TransportItem transportItem;

  const NegotiationScreen({
    super.key,
    required this.user,
    required this.transportItem,
  });

  @override
  State<NegotiationScreen> createState() => _NegotiationScreenState();
}

class _NegotiationScreenState extends State<NegotiationScreen> {
  TextEditingController messageController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // update the message seen status when the screen is opened
    // final chatId =
    //     getChatId(FirebaseAuth.instance.currentUser!.uid, widget.user.uid);
    // Provider.of<NegotiationProvider>(context, listen: false)
    //     .markMessageAsSeen(chatId)
    //     .then((_) {
    //   // print("Message seen status updated");
    // }).catchError((error) {
    //   // print("Error updating message seen status: $error");
    // });
  }

  void _sendMessage() async {
    if (messageController.text.isEmpty) return;

    // print("user id ${widget.user.uid}");
    NegotiationModel message = NegotiationModel(
        receiverId: widget.user.uid!,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        timestamp: DateTime.now().toString(),
        message: messageController.text,
        price: priceController.text
      );
    try {
      await Provider.of<NegotiationProvider>(context, listen: false)
          .addMessage(message);
      messageController.clear();
      priceController.clear();
    } catch (e) {
      // print("Error sending message: $e");
      if (mounted)
        AppUtils.showDialog(context, "Failed to send message ${e.toString()}", AppColors.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final negotiationProvider = Provider.of<NegotiationProvider>(context);
    final chatId =
        getChatId(FirebaseAuth.instance.currentUser!.uid, widget.user.uid);

    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: UserProfileCard(
            header: widget.user.displayName!,
            onPressed: () =>  {context.push('/profile/statistics?userId=${widget.user.uid}')},
            photoUrl: widget.user.photoUrl!,
            headerFontSize: 16,
            subHeaderFontSize: 10,
            avatarSize: 36,
            borderColor: AppColors.blue700,
            headerColor: AppColors.appBarText,
          ),
           iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          systemOverlayStyle:
              SystemUiOverlayStyle.dark,
          backgroundColor: AppColors.white,
           elevation: 0, 
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey, 
              height: 0.6,
            ),
          ),
        ),
        body: Column(children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppTheme.homeScreenPadding,
                    right: AppTheme.homeScreenPadding,
                    // top: 6.0,
                  ),
                  child: StreamBuilder(
                    stream: negotiationProvider.getMessages(chatId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text("Error loading messages"));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No messages yet"));
                      }
                      final messages = snapshot.data ?? [];
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId ==
                              FirebaseAuth.instance.currentUser?.uid;
                          return Column(children: [
                            Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (index == messages.length - 1) ...[
                                      const SizedBox(height: 25),
                                    ],
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 0,
                                        bottom: 5,
                                        left: isMe ? 50 : 0,
                                        right: isMe ? 0 : 50,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isMe
                                            ? AppColors.blue
                                            : AppColors.lessImportant,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(20),
                                          topRight: const Radius.circular(20),
                                          bottomLeft: isMe
                                              ? const Radius.circular(20)
                                              : Radius.zero,
                                          bottomRight: isMe
                                              ? Radius.zero
                                              : const Radius.circular(20),
                                        ),
                                      ),
                                      child: _buildMessageContent(isMe, message),
                                    ),
                                    if (index == 0 && message.seen && isMe) ...[
                                      const Text(
                                        "Seen",
                                        style: TextStyle(
                                            color: AppColors.headingText,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.end,
                                      )
                                    ]
                                  ]),
                            ),
                          ]);
                        },
                      );
                    },
                  ))),
          _buildFooter(),
        ]));
  }

  Widget _buildFooter() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lessImportant,
        border: Border(
          top: BorderSide(
            color: AppColors.blue.withOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
       
        children: [ 
           const Text(
          "Make an offer",
          style: TextStyle(
            color: AppColors.headingText,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFieldWithHeader(
            controller: priceController,
            hintText: "Enter your offer",
            headerText: "Price (DH)",
            keyboardType: TextInputType.number,
            maxLines: 1,
            validator: Validators.notEmpty,
           
          ),
          const SizedBox(height: 16),
          TextFieldWithHeader(
            controller: priceController,
            hintText: "Add a message",
            headerText: "Message (optional)",
            validator: Validators.notEmpty,
            keyboardType: TextInputType.text,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Button(
            hintText: "Send Offer",
            onPressed: _sendMessage,
            isLoading: false,
            backgroundColor: AppColors.blue,
            textColor: Colors.white,
          ),])
      )
      );
  }
  Widget _buildMessageContent(bool isMe, NegotiationModel message) {
    return Row(
      children: [
        Text(
          message.message,
          style: TextStyle(
              color: isMe
                  ? Colors.white
                  : Colors.black),
        ),
      ]
    );
  }
}
