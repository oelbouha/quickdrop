import 'package:quickdrop_app/core/widgets/actionButton.dart';
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
  final VoidCallback onReviewPressed;


  const CompletedItemCard({super.key, 
      required this.item, 
      required this.user,
      required this.onPressed
      ,required this.onViewPressed
      ,required this.onReviewPressed
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column( 
                children: [
                  BuildHeader(
                      from: widget.item.from,
                      to: widget.item.to,
                      id: widget.item.id,
                    ),
                  const SizedBox(height: 16),
                  _buildBody(),
              ])),
            _buildFooter(),
          ],
        )));
  }




  Widget _buildBody() {
    return Column(
      children: [
        // Row(
        //   children: [
        //     Expanded(
        //       child: BuildInfoShip(
        //         icon: Icons.calendar_today,
        //         label: 'Delivered on',
        //         value: '${widget.item.date}',
        //         accentColor: const Color(0xFFDC2626), // Red color for date
        //       ),
        //     ),
        //     const SizedBox(width: 12),
        //     Expanded(
        //       child: BuildInfoShip(
        //         icon:  Icons.inventory_2_outlined,
        //         label: 'Weight',
        //          value: '${widget.item.weight}kg',
        //         accentColor: const Color(0xFF2563EB), // Blue color for weight
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 14,
                  color: const Color(0xFF6B7280),
                ),
                const SizedBox(width: 6),
                Text(
                  'Delivered on: ${widget.item.date}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            // Add price if available in your model
            Text(
              '${widget.item.price}dh',
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.blue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
         const SizedBox(height: 16),
        _buildCourierCard(),
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
  
 Widget _buildFooter() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: BuildShipmentCardActionButton(
              icon: Icons.visibility_outlined,
              label: 'View',
              onPressed: widget.onViewPressed,
              color: const Color(0xFF2563EB),
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: const Color(0xFFE2E8F0),
          ),
          Expanded(
            child: BuildShipmentCardActionButton(
              icon: Icons.rate_review,
              label: 'Review',
              onPressed: widget.onReviewPressed,
              color: AppColors.rateBackground,
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: const Color(0xFFE2E8F0),
          ),
          Expanded(
            child: BuildShipmentCardActionButton(
              icon: Icons.delete_outline,
              label: 'Delete',
              onPressed: widget.onPressed,
              color: const Color(0xFFDC2626),
            ),
          ),
        ],
      ),
    );
  }


}





 