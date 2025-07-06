import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/base_transport.dart';
export 'package:quickdrop_app/core/widgets/user_profile.dart';
export 'package:quickdrop_app/core/widgets/review.dart';

class CompletedItemCard extends StatefulWidget {
 final TransportItem item;
  final UserData user;
  final VoidCallback onPressed;
  final VoidCallback onViewPressed;


  const CompletedItemCard({super.key, 
      required this.item, 
      required this.user,
      required this.onPressed
      ,required this.onViewPressed
    });

  @override
  CompletedItemCardState createState() => CompletedItemCardState();
}

class CompletedItemCardState extends State<CompletedItemCard> {
  final reviewController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: widget.onViewPressed, child: Container(
      // height: 120,
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
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeader(),
            _buildBody(),
            _buildFooter(),
          ],
        )));
  }



  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Destination
          Row(
            children: [
              Expanded(
                child: Destination(
                  from: widget.item.from,
                  to: widget.item.to,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Details Grid
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.cardBackground.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  icon: "assets/icon/calendar.svg",
                  label: "Departure",
                  value: widget.item.date,
                  iconColor: AppColors.blue600,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  icon: "assets/icon/weight.svg",
                  label: "Weight",
                  value: "${widget.item.weight} kg",
                  iconColor: AppColors.blue600,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Courier Information
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
            ],
          ),
        ],
      ),
    );
  }
  

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.completedstatusBackground.withOpacity(0.3),
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
              color: AppColors.completedstatusBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.completedStatusText.withOpacity(0.3),
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
                    color: AppColors.completedStatusText,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  "Completed",
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.completedStatusText,
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



  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardFooterBackground,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(AppTheme.cardRadius),
          bottomLeft: Radius.circular(AppTheme.cardRadius),
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.cardBackground.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Price
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            // decoration: BoxDecoration(
            //   color: AppColors.blue.withOpacity(0.1),
            //   borderRadius: BorderRadius.circular(20),
            //   border: Border.all(
            //     color: AppColors.blue.withOpacity(0.2),
            //     width: 1,
            //   ),
            // ),
            child: Text(
              '${widget.item.price} DH',
              style: const TextStyle(
                color: AppColors.blue,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          
          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                icon: "assets/icon/star.svg",
                label: "Rate trip",
                color: AppColors.rateBackground,
                backgroundColor: AppColors.rateBackground.withOpacity(0.1),
                onTap: _submitReview,
                isDestructive: false,
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: "assets/icon/report.svg",
                label: "Report",
                color: AppColors.error,
                backgroundColor: AppColors.error.withOpacity(0.1),
                onTap: ()  {
                  AppUtils.showDialog(context, "Report feature is not available yet", AppColors.blue700);
                },
                isDestructive: true,
                iconWidget: const Icon(Icons.cancel_outlined, size: 14),
              ),
            ],
          ),
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
    required bool isDestructive,
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
          ),
        ),
      ),
    );
  }

 

}
