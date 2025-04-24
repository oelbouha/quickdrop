import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
// import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/widgets/button.dart';
import 'package:quickdrop_app/core/widgets/item_details.dart';
import 'package:quickdrop_app/core/widgets/user_profile.dart';
import 'package:quickdrop_app/features/chat/convo_screen.dart';

class ChatConversationCard extends StatefulWidget {
  final String? photoUrl;
  final String? header;
  final String? subHeader;
  final String? userId;
  const ChatConversationCard({
    super.key,
    required this.photoUrl,
    required this.header,
    required this.subHeader,
    required this.userId,
  });

  @override
  ChatConversationCardState createState() => ChatConversationCardState();
}

class ChatConversationCardState extends State<ChatConversationCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(
                      user: {
                        'uid': widget.userId,
                        'displayName': widget.header,
                        'photoUrl': widget.photoUrl,
                      },
                    )),
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
                subHeader: widget.subHeader!,
                headerFontSize: 14,
                subHeaderFontSize: 10,
                avatarSize: 18,
              )
            ],
          ),
        ));
  }
}
