import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:intl/intl.dart';
import 'package:quickdrop_app/features/models/report_model.dart';
import 'package:quickdrop_app/features/models/review_model.dart'; 
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportDialog extends StatefulWidget {
  final UserData recieverUser;

  const ReportDialog({
    super.key,
    required this.recieverUser,
  });

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final reportController = TextEditingController();
  final String iconPath = "assets/icon/report.svg";
  bool _isLoading = false;

  void _submitReport() async{
    if (_isLoading) return;

    try {
      final String message = reportController.text.trim();
      if (message.isEmpty) {
        AppUtils.showDialog(
          context,
          'Please describe the problem before submitting.',
          AppColors.error,
        );
        return;
      }


      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        AppUtils.showDialog(
            context, 'Please log in to report a problem', AppColors.error);
        return;
      }

      ReportModel report = ReportModel(
        receiverId: widget.recieverUser.uid,
        senderId: user.uid,
        date: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
        message: message,
      );

      await FirebaseFirestore.instance.collection('reports').add(report.toMap());

      AppUtils.showDialog(
          context, "Problem reported successfully!", AppColors.succes);
    } catch (e) {
      if (mounted) {
        AppUtils.showDialog(
            context, "Failed to submit report", AppColors.error);
      }
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
      child: SingleChildScrollView(
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
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Report a Problem",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.headingText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Please describe the issue you encountered with this user",
                style: TextStyle(fontSize: 14, color: AppColors.shipmentText),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: reportController,
                hintText: "Describe the problem...",
                backgroundColor: AppColors.cardBackground,
                maxLines: 4,
                validator: Validators.notEmpty,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Button(
                  onPressed: _submitReport,
                  hintText: "Submit Report",
                  isLoading: _isLoading,
                  backgroundColor: AppColors.blue700,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
