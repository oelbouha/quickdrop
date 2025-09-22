import 'package:quickdrop_app/core/widgets/build_header_icon.dart';
import 'package:quickdrop_app/features/chat/chat_conversation_card.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdrop_app/core/utils/imports.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  UserData? user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.blue,
          centerTitle: true,
          // elevation: 0,
          title: const Text(
            "Chats",
            style:  TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            buildHeaderIcon(
              icon: "assets/icon/help.svg",
              onTap: () => print("Help tapped"),
              color: AppColors.white
            ),
            const SizedBox(width: 8),
            const NotificationIcon(
              color: AppColors.white
            ),
            const SizedBox(width: 12),
          ]
        
        ),
        body:  _buildChatConversations(),
    );
  }



  Widget _buildChatConversations() {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Container(
        margin: const EdgeInsets.only(
            left: AppTheme.cardPadding, right: AppTheme.cardPadding),
        child: StreamBuilder(
          stream: chatProvider.getConversations(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ?  loadingAnimation()
              : snapshot.hasError
                  ? const Center(child: Text("Error loading conversations"))
                  : snapshot.hasData && (snapshot.data as List).isNotEmpty
                      ? ListView.builder(
                          itemCount: (snapshot.data as List).length,
                          itemBuilder: (context, index) {
                            // print("data ${snapshot.data as List}");
                            // final user =
                            if (snapshot.data == null) {
                              return  buildEmptyState(
                                      Icons.chat_bubble,
                                      "No Conversation yet",
                                      "Your chat conversations will appear here once you start messaging"
                                  );
                            }
                            final conversation = (snapshot.data as List)[index];
                            if (conversation['userId'] == null || conversation == null) {
                              return const SizedBox.shrink();
                            }
                            // List<Map<String, dynamic>> user = conversation['user'];
                            // print("user data: ${user}");
                            // print("sender id: ${conversation['participants'][0]}");
                            return Column(children: [
                              if (index == 0)
                                const SizedBox(
                                    height: AppTheme.gapBetweenCards),
                              ChatConversationCard(
                                header: conversation['userName'] ?? 'Guest',
                                subHeader: conversation['lastMessage'] ?? 'No messages yet',
                                photoUrl: conversation['photoUrl'] ?? AppTheme.defaultProfileImage,
                                userId: conversation['userId'],
                                isMessageSeen: conversation['lastMessageSeen'],
                                messageSender:
                                    conversation['lastMessageSender'],
                              ),
                              const SizedBox(height: AppTheme.gapBetweenCards),
                            ]);
                          },
                        )
                      :buildEmptyState(
                          Icons.chat_bubble,
                          "No Conversation yet",
                          "Your chat conversations will appear here once you start messaging"
                      )
        ));
  }




}
