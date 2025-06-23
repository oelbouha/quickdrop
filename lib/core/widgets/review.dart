import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/providers/review_provider.dart';
import 'package:intl/intl.dart';

import 'package:quickdrop_app/features/models/review_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewDialog extends StatefulWidget {
  final UserData recieverUser;

  const ReviewDialog({
    super.key,
    required this.recieverUser,
  });

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
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
            context, 'Please log in to list a shipment', AppColors.error);
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
          context, "Review Submitted succesfully!", AppColors.succes);
    } catch (e) {
      if (mounted)
        AppUtils.showDialog(
            context, "Failed to submit review ", AppColors.error);
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
    return Dialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
      child: Padding(
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
            const Text(
              "Rate your experience",
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.headingText,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              "Please rate your experience with the shipment",
              style: TextStyle(fontSize: 14, color: AppColors.shipmentText),
            ),
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
            const SizedBox(height: 10),
            CustomTextField(
              controller: reviewController,
              hintText: "Share your thoughts about the user",
              backgroundColor: AppColors.cardBackground,
              maxLines: 3,
              validator: Validators.notEmpty,
            ),
            const SizedBox(height: 20),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Button(
                  onPressed: _submitReview,
                  hintText: "Submit Review",
                  isLoading: false,
                  backgroundColor: AppColors.blue700,
                ))
          ],
        ),
      ),
    );
  }
}
