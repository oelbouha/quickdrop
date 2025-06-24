
import 'package:go_router/go_router.dart';
// import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/widgets/button.dart';
import 'package:quickdrop_app/core/widgets/item_details.dart';
import 'package:quickdrop_app/features/chat/convo_screen.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

class NegotiationCard extends StatefulWidget {
  /// A card that displays a chat conversation with a user.
  ///
  final String? photoUrl;
  final String? header;
  final String? subHeader;
  final String? userId;
  final String? messageSender;
  final bool isMessageSeen;
  final String shipmentId;
  final String requestId;

  const NegotiationCard({
    super.key,
    required this.photoUrl,
    required this.messageSender,
    required this.header,
    required this.subHeader,
    required this.userId,
    required this.shipmentId,
    required this.requestId,
    this.isMessageSeen = false,
  });

  @override
  NegotiationCardState createState() => NegotiationCardState();
}

class NegotiationCardState extends State<NegotiationCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.push('/negotiation-screen?userId=${widget.userId}&shipmentId=${widget.shipmentId}&requestId=${widget.requestId}');
        },
        child: Container(
          // padding: const EdgeInsets.all(AppTheme.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0.2,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
          children: [
            _buildStatusBanner(),
           _buildHeader(),
          // _buildBottomStatusBanner(),
          ],)
        ));
  }


  Widget _buildHeader() {
   return  Container(
      padding: const EdgeInsets.all(16),
      child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserProfileCard(
                photoUrl: widget.photoUrl ?? AppTheme.defaultProfileImage,
                header: widget.header!,
                onPressed: () => print("user profile  Clicked"),
                headerFontSize: 16,
                subHeaderFontSize: 12,
                avatarSize: 40,
                subHeader: widget.subHeader!,
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
           
      )
    );
  }

  
  Widget _buildStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.warning.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: const  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            size: 16,
            color: AppColors.warning,
          ),
          SizedBox(width: 4),
          Text(
             'Negotiation exires in 24 hours',
            style: TextStyle(
              color: AppColors.warning,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.warning.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: const  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            size: 16,
            color: AppColors.warning,
          ),
          SizedBox(width: 4),
          Text(
            'Negotiation exires in 24 hours',
            style: TextStyle(
              color: AppColors.warning,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

}
