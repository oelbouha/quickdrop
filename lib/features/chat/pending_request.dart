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

class DeliveryRequestState extends State<PendingRequest> {
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
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatusBanner(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.warning.withOpacity(0.1),
            AppColors.warning.withOpacity(0.05),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.access_time_rounded,
              size: 16,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Waiting for response',
            style: TextStyle(
              color: AppColors.warning,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
          child: Destination(
            from: widget.shipment.from,
            to: widget.shipment.to,
          ),
        ),
        const SizedBox(height: 16),
        _buildPriceCard(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPriceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.primary.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.local_offer,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offered Price',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.shipmentText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.request.price} dh',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildUserSection(),
          const SizedBox(height: 20),
          // _buildMainContent(),
          _buildBody(),
          const SizedBox(height: 20),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildUserSection() {
    return UserProfileWithRating(
      user: widget.user,
      header: widget.user.displayName ?? 'Guest',
      avatarSize: 40,
      headerFontSize: 16,
      subHeaderFontSize: 12,
      onPressed: () =>
          {context.push('/profile/statistics?userId=${widget.user.uid}')},
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
          _isProcessing ? 'Cancelling Request...' : 'Cancel Request',
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
