import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/review.dart';
import 'package:quickdrop_app/features/models/base_transport.dart';
export 'package:quickdrop_app/core/widgets/user_profile.dart';
import 'package:quickdrop_app/features/chat/convo_screen.dart';

class OngoingItemCard extends StatefulWidget {
  final TransportItem item;
  final UserData user;
  final VoidCallback onViewPressed;
  
  const OngoingItemCard({
    super.key,
    required this.item,
    required this.user,
    required this.onViewPressed,
  });

  @override
  OngoingItemCardState createState() => OngoingItemCardState();
}

class OngoingItemCardState extends State<OngoingItemCard> {
  void _submitReview() {
    showDialog(
      context: context,
      builder: (context) {
        return ReviewDialog(
          recieverUser: widget.user,
        );
      },
    );
  }

  void _contactCourier() async {
    context.push(
      "/convo-screen",
      extra: {
        'uid': widget.user.uid,
        'displayName': widget.user.displayName ?? "Unknown user",
        'photoUrl': widget.user.photoUrl ?? AppTheme.defaultProfileImage,
      },
    );
  }

  void markShipmentAsDelivered(String id) async {
    try {
      _submitReview();
      if (widget.item is Shipment) {
        await Provider.of<ShipmentProvider>(context, listen: false)
            .updateStatus(id, DeliveryStatus.completed);
        Provider.of<StatisticsProvider>(context, listen: false)
            .incrementField(widget.item.userId, "completedShipments");
        Provider.of<StatisticsProvider>(context, listen: false)
            .decrementField(widget.item.userId, "ongoingShipments");
      }
      if (widget.item is Trip) {
        await Provider.of<TripProvider>(context, listen: false)
            .updateStatus(id, DeliveryStatus.completed);
        Provider.of<StatisticsProvider>(context, listen: false)
            .incrementField(widget.item.userId, "completedTrips");
        Provider.of<StatisticsProvider>(context, listen: false)
            .decrementField(widget.item.userId, "ongoingTrips");
      }
    } catch (e) {
      if (mounted) AppUtils.showDialog(context, "Failed to update shipment", AppColors.error);
    }
  }

  void _showDeliveryConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.succes.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const CustomIcon(
                  iconPath: "assets/icon/check-circle.svg",
                  size: 20,
                  color: AppColors.succes,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Mark as Delivered',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure this item has been delivered successfully?',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.succes.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.succes.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.item.from} → ${widget.item.to}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Courier: ${widget.user.displayName ?? "Unknown"}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Price: ${widget.item.price} DH',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This will complete the delivery and you\'ll be asked to rate the courier.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.succes,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Not Yet',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                markShipmentAsDelivered(widget.item.id!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.succes,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Mark Delivered',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.cancel_outlined,
                  size: 20,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Cancel Delivery',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to cancel this ongoing delivery?',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.error.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.item.from} → ${widget.item.to}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Courier: ${widget.user.displayName ?? "Unknown"}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please contact the courier before canceling to avoid any issues.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Keep Active',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add your cancel logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Cancel Delivery',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onViewPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
          border: Border.all(
            color: AppColors.cardBackground.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildBody(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.ongoingstatusBackground.withOpacity(0.3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.cardRadius),
          topRight: Radius.circular(AppTheme.cardRadius),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.ongoingstatusBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.ongoingStatusText.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.ongoingStatusText,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  "In Progress",
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.ongoingStatusText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            'ID: #${widget.item.id ?? 'N/A'}',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildBody() {
    return Padding(
        padding: const EdgeInsets.all(16),
      child:  Column(children: [ 
      Row(
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
            from: widget.item.from,
            to: widget.item.to,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: buildPriceCard(price: widget.item.price, label: 'Delivery Price')),
      ],
    ),
     const SizedBox(height: 16),
      _buildCourierCard(),
     ],
      ),
    );
  }


  Widget _buildDetailRow({
    required String icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: CustomIcon(
            iconPath: icon,
            size: 12,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildCourierCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.courierInfoBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.blue.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CustomIcon(
                iconPath: "assets/icon/user.svg",
                size: 14,
                color: AppColors.blue600,
              ),
              const SizedBox(width: 6),
              Text(
                'Your Courier',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: UserProfileWithRating(
                  user: widget.user,
                  header: widget.user.displayName ?? 'Guest',
                  avatarSize: 36,
                  headerFontSize: 12,
                  subHeaderFontSize: 9,
                  onPressed: () => {
                    context.push('/profile/statistics?userId=${widget.user.uid}')
                  },
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _contactCourier,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.contactBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.blue.withOpacity(0.2),
                        width: 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blue.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CustomIcon(
                          iconPath: "assets/icon/chat-round-line.svg",
                          size: 16,
                          color: AppColors.blue,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Chat',
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _buildActionButton(
            label: "Delivered",
            color: AppColors.succes,
            backgroundColor: AppColors.succes.withOpacity(0.1),

              // borderColor: AppColors.succes,
            onTap: _showDeliveryConfirmation,

            iconWidget: const Icon(Icons.done_all_rounded, size: 14),
          )),
          const SizedBox(width: 8),
          Expanded(child: _buildActionButton(
            label: "Cancel",
            color: const Color(0xFFb91c1c), // red-700
              backgroundColor: const Color(0xFFfef2f2), // red-50
              // borderColor: const Color(0xFFfecaca), // red-200
            onTap: _showCancelConfirmation,
            iconWidget: const Icon(Icons.cancel_outlined, size: 14),
          )),
        ],
         
      ),
    );
  }

  Widget _buildActionButton({
    String? icon,
    Widget? iconWidget,
    required String label,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 0.5,
            ),
          ),
          child: Center(child:Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            // center the row

            children: [
              if (icon != null)
                CustomIcon(
                  iconPath: icon,
                  size: 14,
                  color: color,
                )
              else if (iconWidget != null)
                IconTheme(
                  data: IconThemeData(color: color),
                  child: iconWidget,
                ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }


}

