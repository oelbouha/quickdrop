import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';


class PendingRequest extends StatefulWidget {
  final DeliveryRequest request;
  final UserData user;
  final TransportItem shipment;

  const PendingRequest({
    super.key,
    required this.request,
    required this.user,
    required this.shipment,
  });

  @override
  DeliveryRequestState createState() => DeliveryRequestState();
}

class DeliveryRequestState extends State<PendingRequest>
     {
  bool _isProcessing = false;

  

  void _refuseRequest() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      await Provider.of<DeliveryRequestProvider>(context, listen: false)
          .deleteRequest(widget.request.id!);

      if (mounted) {
        AppUtils.showDialog(
            context, "Request cancelled successfully", AppColors.succes);
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showDialog(
            context, "Failed to cancel request", AppColors.error);
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatusBanner(),
          _buildHeader(),
          _buildBody(),
          _buildFooter(),
        ],
      ),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            size: 16,
            color: AppColors.warning,
          ),
          const SizedBox(width: 4),
          Text(
            'Waiting for response',
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

  Widget _buildHeader() {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: UserProfileWithRating(
          user: widget.user,
          header: widget.user.displayName ?? 'Guest',
          avatarSize: 34,
          headerFontSize: 10,
          subHeaderFontSize: 8,
          onPressed: () =>
              {context.push('/profile/statistics?userId=${widget.user.uid}')},
        ));
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Destination(
              from: widget.shipment.from,
              to: widget.shipment.to,
            ),
          ),
          const SizedBox(height: 16),
          _buildRequestDetails(),
        ],
      ),
    );
  }

  Widget _buildRequestDetails() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.headingText.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          _buildDetailItem(
            icon: Icons.local_offer,
            label: 'Your Offer',
            value: '${widget.request.price} dh',
            valueColor: AppColors.primary,
          ),
          const SizedBox(width: 16),
          Container(
            width: 1,
            height: 40,
            color: AppColors.headingText.withOpacity(0.3),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.shipmentText),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.shipmentText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _isProcessing ? null : _refuseRequest,
              icon: _isProcessing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.error),
                      ),
                    )
                  : const Icon(Icons.close, size: 18),
              label: Text(_isProcessing ? 'Cancelling...' : 'Cancel Request'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'Recently';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
