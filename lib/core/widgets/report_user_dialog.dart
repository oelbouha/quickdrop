import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:intl/intl.dart';
import 'package:quickdrop_app/features/models/report_model.dart';
import 'package:quickdrop_app/features/models/review_model.dart'; 
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportUserDialog extends StatefulWidget {
  final UserData recieverUser;

  const ReportUserDialog({
    super.key,
    required this.recieverUser,
  });

  @override
  State<ReportUserDialog> createState() => _ReportUserDialogState();
}

class _ReportUserDialogState extends State<ReportUserDialog> {
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
          AppLocalizations.of(context)!.report_describe_problem,
          AppColors.error,
        );
        return;
      }


      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        AppUtils.showDialog(
            context, AppLocalizations.of(context)!.login_required, AppColors.error);
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
          context, AppLocalizations.of(context)!.report_submitted_success, AppColors.succes);
    } catch (e) {
      if (mounted) {
        AppUtils.showDialog(
            context, AppLocalizations.of(context)!.report_submit_failed, AppColors.error);
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
              Text(
                AppLocalizations.of(context)!.report_problem_title,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.headingText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.report_problem_subtitle,
                style: const TextStyle(fontSize: 14, color: AppColors.shipmentText),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: reportController,
                hintText: AppLocalizations.of(context)!.report_hint_text,
                // backgroundColor: AppColors.cardBackground,
                maxLines: 4,
                validator: Validators.notEmpty,
                displayLabel: false,
              ),
              const SizedBox(height: 16),
              IconTextButton(
                iconPath: "assets/icon/submit.svg",
                isLoading: _isLoading,
                onPressed: _submitReport,
                hint: AppLocalizations.of(context)!.submit_report_button,
                loadingText: AppLocalizations.of(context)!.saving,
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}