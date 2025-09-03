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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column( 
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildBody(),
              ])),
            _buildFooter(),
          ],
        )));
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
        const SizedBox(height: 16),
        _buildCourierCard(),
      ],
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
      child: Row(
        children: [
          Expanded(
            child: buildActionButton(
              label: 'Report',
              onPressed: () => {},
              isLeft: true,
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: const Color(0xFFE5E7EB), // gray-200
          ),
          Expanded(
            child: buildActionButton(
              label: 'Review',
              onPressed: _submitReview,
              isLeft: false,
            ),
          ),
        ],
      ),
    );

   
  }




}





 