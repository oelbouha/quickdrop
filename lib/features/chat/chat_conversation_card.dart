
import 'package:go_router/go_router.dart';
// import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/widgets/button.dart';
import 'package:quickdrop_app/core/widgets/item_details.dart';
import 'package:quickdrop_app/features/chat/convo_screen.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

class ChatConversationCard extends StatefulWidget {
  /// A card that displays a chat conversation with a user.
  ///
  final String? photoUrl;
  final String? header;
  final String? subHeader;
  final String? userId;
  final String? messageSender;
  final bool isMessageSeen;

  const ChatConversationCard({
    super.key,
    required this.photoUrl,
    required this.messageSender,
    required this.header,
    required this.subHeader,
    required this.userId,
    this.isMessageSeen = false,
  });

  @override
  ChatConversationCardState createState() => ChatConversationCardState();
}

class ChatConversationCardState extends State<ChatConversationCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.push("/convo-screen",
            extra: {
              'uid': widget.userId,
              'displayName': widget.header,
              'photoUrl': widget.photoUrl,
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(AppTheme.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0.2,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserProfileCard(
                photoUrl: widget.photoUrl!,
                header: widget.header!,
                onPressed: () => print("user profile  Clicked"),
                headerFontSize: 16,
                subHeaderFontSize: 12,
                avatarSize: 20,
                subHeader: widget.subHeader! ,
                subHeaderColor: widget.isMessageSeen == false && widget.messageSender == widget.userId
                    ? AppColors.shipmentText:
                     AppColors.lessImportant,
              ),
              if (widget.isMessageSeen == false && widget.messageSender == widget.userId)
                const Icon(
                  Icons.circle,
                  size: 12,
                  color: AppColors.succes,
                ),
            ],
          ),
        ));
  }
}
