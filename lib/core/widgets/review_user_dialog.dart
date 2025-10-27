import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/providers/review_provider.dart';
import 'package:intl/intl.dart';

import 'package:quickdrop_app/features/models/review_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewUserDialog extends StatefulWidget {
  final UserData recieverUser;

  const ReviewUserDialog({
    super.key,
    required this.recieverUser,
  });

  @override
  State<ReviewUserDialog> createState() => _ReviewUserDialogState();
}

class _ReviewUserDialogState extends State<ReviewUserDialog> {
  double _rating = 5;
  final reviewController = TextEditingController();
  final String iconPath = "assets/icon/star.svg";
  bool _isLoading = false;

  void _submitReview() {
    if (_isLoading) return;

    try {
      final String message = reviewController.text;
      final reviewProvider =
          Provider.of<ReviewProvider>(context, listen: false);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        AppUtils.showDialog(
            context, AppLocalizations.of(context)!.login_required, AppColors.error);
        return;
      }

      ReviewModel review = ReviewModel(
          receiverId: widget.recieverUser.uid,
          senderId: user.uid,
          date: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
          message: message,
          rating: _rating);

      reviewProvider.addReview(review);

      AppUtils.showDialog(
          context, AppLocalizations.of(context)!.review_submitted_success, AppColors.succes);
    } catch (e) {
      if (mounted)
        AppUtils.showDialog(
            context, AppLocalizations.of(context)!.review_submit_failed, AppColors.error);
      // print(e);
    } finally {
      Navigator.pop(context);
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Dialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
      child: SingleChildScrollView (child:Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 20,
          right: 20,
          bottom: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.deleteBackground,
                ),
                child: CustomIcon(
                  iconPath: iconPath,
                  color: AppColors.error,
                )),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.rate_experience_title,
              style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.headingText,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              AppLocalizations.of(context)!.rate_experience_subtitle,
              style: const TextStyle(fontSize: 14, color: AppColors.shipmentText),
            ),
             const SizedBox(height: 16),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => CustomIcon(
                iconPath: iconPath,
                color: AppColors.rateBackground,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: reviewController,
              hintText: AppLocalizations.of(context)!.review_hint_text,
              // backgroundColor: AppColors.cardBackground,
              maxLines: 3,
              validator: Validators.notEmpty,
              displayLabel: false,
            ),
            const SizedBox(height: 16),
            IconTextButton(
              iconPath: "assets/icon/submit.svg",
              isLoading: _isLoading,
              onPressed: _submitReview,
              hint: AppLocalizations.of(context)!.submit_review_button,
              loadingText: AppLocalizations.of(context)!.saving,
            ),
           
          ],
        ),
      ),)
    );
  }
}