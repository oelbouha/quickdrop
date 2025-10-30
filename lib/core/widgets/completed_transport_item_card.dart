
import 'package:quickdrop_app/core/utils/imports.dart';
export 'package:quickdrop_app/core/widgets/user_profile_avatar.dart';
export 'package:quickdrop_app/core/widgets/review_user_dialog.dart';

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
        return ReviewUserDialog(
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
                      price: widget.item.price
                    ),
                  const SizedBox(height: 16),
                  buildShipmentBody(context, widget.item.date, widget.item.weight ),
                    const SizedBox(height: 16),
                  _buildCourierCard(),
              ])),
            _buildFooter(),
          ],
        )));
  }




  Widget _buildCourierCard() {
    final t = AppLocalizations.of(context)!;
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
                t.courier,
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
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 8
      ),
      child:  Row(
      children: [

        Expanded(
          child: BuildPrimaryButton(
            onPressed: _submitReview,
            label: AppLocalizations.of(context)!.review,
            color: AppColors.rateBackground,
            icon: "assets/icon/star.svg"
          ),
        ),
        const SizedBox(width: 12),
        SecondaryButton(
          icon: "assets/icon/eye.svg",
          onPressed: widget.onViewPressed,
        ),
        // const SizedBox(width: 12),
        // BuildSecondaryButton(
        //   icon: Icons.delete_outline,
        //   onPressed: widget.onViewPressed,
        // ),
      ],
    ));
  }
   


}





 