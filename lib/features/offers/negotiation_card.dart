
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
// import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/widgets/button.dart';
import 'package:quickdrop_app/core/widgets/item_details.dart';
import 'package:quickdrop_app/features/chat/convo_screen.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/providers/negotiation_provider.dart';
import 'package:quickdrop_app/features/models/negotiation_model.dart';


class NegotiationCard extends StatefulWidget {

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

   bool _isProcessing = false;



  void _refuseRequest() async {
     if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });
    
    try {
        await FirebaseFirestore.instance.runTransaction((transaction) async {

        await Provider.of<DeliveryRequestProvider>(context, listen: false)
          .deleteRequest(widget.requestId);
        // final chatId = getChatId(FirebaseAuth.instance.currentUser!.uid, widget.user.uid);
        await Provider.of<NegotiationProvider>(context, listen: false).deleteNegotiation(widget.requestId); 
      });

      if (mounted) {
        context.pop();
        AppUtils.showDialog(context, "Request refused successfully", AppColors.succes);
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showDialog(context, "Failed to refuse request $e", AppColors.error);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }


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
                color: Colors.black.withValues(alpha: 0.1),
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
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //   child: _buildActionButton()),
           ],
          )
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
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.warning.withValues(alpha: 0.2),
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
             'Negotiation in progress',
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


  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _isProcessing ? null : _refuseRequest,
        icon: _isProcessing
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(
                Icons.close_rounded,
                size: 20,
                color: Colors.white,
              ),
        label: Text(
          _isProcessing ? 'Cancelling...' : 'Cancel Negotiation',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          disabledBackgroundColor: AppColors.error.withOpacity(0.6),
        ),
      ),
    );
  }


}
