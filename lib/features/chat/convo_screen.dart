import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/chat_model.dart';

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
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // update the message seen status when the screen is opened
    final chatId =
        getChatId(FirebaseAuth.instance.currentUser!.uid, widget.user['uid']);
    Provider.of<ChatProvider>(context, listen: false)
        .markMessageAsSeen(chatId)
        .then((_) {
      // print("Message seen status updated");
    }).catchError((error) {
      // print("Error updating message seen status: $error");
    });
  }

  void _sendMessage() async {
    if (messageController.text.isEmpty) return;

    // print("user id ${widget.user['uid']}");
    ChatModel message = ChatModel(
        receiverId: widget.user['uid'],
        senderId: FirebaseAuth.instance.currentUser!.uid,
        timestamp: DateTime.now().toString(),
        text: messageController.text,
        type: "text");
    try {
      await Provider.of<ChatProvider>(context, listen: false)
          .addMessage(message);
      messageController.clear();
    } catch (e) {
      // print("Error sending message: $e");
      if (mounted) {
        AppUtils.showDialog(
            context, "Failed to send message ${e.toString()}", AppColors.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final chatId =
        getChatId(FirebaseAuth.instance.currentUser!.uid, widget.user['uid']);
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: UserProfileCard(
            header: widget.user['displayName'],
            onPressed: () => {
              context.push('/profile/statistics?userId=${widget.user['uid']}')
            },
            photoUrl: widget.user['photoUrl'],
            headerFontSize: 16,
            subHeaderFontSize: 10,
            avatarSize: 40,
            borderColor: AppColors.blue700,
            headerColor: AppColors.dark,
          ),
          iconTheme: const IconThemeData(
            color: Colors.black, // Set the arrow back color to black
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
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
                    stream: chatProvider.getMessages(chatId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // return  Center(child: loadingAnimation());
                      }
                      if (!snapshot.hasData) {
                        // First time loading only
                        return Center(child: loadingAnimation());
                      }

                      if (snapshot.hasError) {
                        return Center(
                            child: buildEmptyState(
                                Icons.error,
                                AppLocalizations.of(context)!
                                    .error_loading_message,
                                AppLocalizations.of(context)!
                                    .error_loading_message_text));
                      }
                      // if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      //   return const Center(child: Text("No messages yet"));
                      // }
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
                                      child: Text(
                                        message.text,
                                        style: TextStyle(
                                            color: isMe
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ),
                                    if (index == 0 && message.seen && isMe) ...[
                                      Text(
                                        AppLocalizations.of(context)!.seen,
                                        style: const TextStyle(
                                            color: AppColors.headingText,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.end,
                                      )
                                    ]
                                  ]),
                            ),
                            // const SizedBox(height: 5),
                            //   const Text(
                            //     "12:00 PM",
                            //     style: TextStyle(
                            //         color: AppColors.lessImportant, fontSize: 10),
                            //   ),
                            // const SizedBox(height: 5),
                          ]);
                        },
                      );
                    },
                  ))),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  onChanged: (text) {
                    // Handle text input
                    // print("Text input: $text");
                  },
                  style: const TextStyle(
                    color: AppColors.headingText,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                        padding: const EdgeInsets.only(
                          right: 8.0,
                          top: 4.0,
                          bottom: 4.0,
                        ),
                        child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.blue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IconButton(
                                icon: CustomIcon(
                                  iconPath: isArabic
                                      ? "assets/icon/send-left.svg"
                                      : "assets/icon/send.svg",
                                  color: AppColors.white,
                                  size: 34,
                                ),
                                onPressed: _sendMessage))),
                    filled: true,
                    fillColor: AppColors.blue.withOpacity(0.2),
                    hintText: AppLocalizations.of(context)!.type_a_message,
                    border: const OutlineInputBorder(
                      // borderSide: BorderSide.none, // Removes visible border
                      borderRadius: BorderRadius.all(Radius.circular(
                          AppTheme.chatInputRadius)), // Adds border radius
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.blue.withOpacity(0.1), width: 1.0),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(AppTheme.chatInputRadius)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.blue.withOpacity(0.1), width: 1.0),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(AppTheme.chatInputRadius)),
                    ),
                  ),
                )),
              ]))
        ]));
  }
}
