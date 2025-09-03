import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/review.dart';
import 'package:quickdrop_app/features/models/base_transport.dart';

class CompletedItemCard extends StatefulWidget {
  final TransportItem item;
  final UserData user;
  final VoidCallback onPressed;
  final VoidCallback onViewPressed;

  const CompletedItemCard({
    super.key,
    required this.item,
    required this.user,
    required this.onPressed,
    required this.onViewPressed,
  });

  @override
  CompletedItemCardState createState() => CompletedItemCardState();
}

class CompletedItemCardState extends State<OngoingItemCard> {
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
    return GestureDetector(
      onTap: widget.onViewPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildBody(),
                ])),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${widget.item.id ?? 'N/A'}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280), // gray-500
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.item.from} → ${widget.item.to}',
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF111827), // gray-900
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7), // green-100
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Delivered',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF10B981), // success color
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivered on: ${widget.item.date}',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280), // gray-500
            fontWeight: FontWeight.w400,
          ),
        ),
        // const SizedBox(height: 4),
        // Text(
        //   _formatDriverInfo(),
        //   style: const TextStyle(
        //     fontSize: 14,
        //     color: Color(0xFF6B7280), // gray-500
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        const SizedBox(height: 16),
        _buildCourierCard(),
      ],
    );
  }

  Widget _buildCourierCard() {
    // if (widget.user == null) return SizedBox.shrink();
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
                    context
                        .push('/profile/statistics?userId=${widget.user.uid}')
                  },
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
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E7EB), // gray-200
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              label: 'Report Issue',
              backgroundColor: const Color(0xFFF3F4F6), // gray-100
              textColor: const Color(0xFF6B7280), // gray-500
              onPressed: () => {},
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionButton(
              label: 'Leave Review',
              backgroundColor: const Color(0xFFF59E0B), // gold
              textColor: Colors.white,
              onPressed: () => _submitReview(),
              icon: Icons.star,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: textColor,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildActionButton({
  required String label,
  required Color color,
  required Color backgroundColor,
  required Color borderColor,
  required VoidCallback onTap,
  required Widget iconWidget,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(color: color),
              child: iconWidget,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildHeader({
  required id,
  required label,
  required Color backgroundColor,
  Color circleColor = const Color(0xFF10b981),
  Color gradientStart = const Color(0xFFdbeafe),
  Color gradientEnd = const Color(0xFFe0e7ff),
}) {
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
              Text(
                label,
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
          'ID: #${id ?? 'N/A'}',
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
