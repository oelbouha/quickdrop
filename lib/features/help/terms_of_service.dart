import 'package:quickdrop_app/core/utils/imports.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          t.terms_of_service_title,
          style: const TextStyle(color: AppColors.appBarText, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.appBarBackground,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.appBarIcons),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              t.terms_last_updated,
              '',
              isDate: true,
            ),
            _buildSection(
              t.terms_acceptance_title,
              t.terms_acceptance_content,
            ),
            _buildSection(
              t.terms_description_title,
              t.terms_description_content,
            ),
            _buildSection(
              t.terms_user_responsibilities_title,
              t.terms_user_responsibilities_content,
            ),
            _buildSection(
              t.terms_prohibited_items_title,
              t.terms_prohibited_items_content,
            ),
            _buildSection(
              t.terms_liability_title,
              t.terms_liability_content,
            ),
            _buildSection(
              t.terms_user_conduct_title,
              t.terms_user_conduct_content,
            ),
            _buildSection(
              t.terms_account_termination_title,
              t.terms_account_termination_content,
            ),
            _buildSection(
              t.terms_privacy_title,
              t.terms_privacy_content,
            ),
            _buildSection(
              t.terms_modifications_title,
              t.terms_modifications_content,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, {bool isDate = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isDate ? 14 : 18,
              fontWeight: isDate ? FontWeight.normal : FontWeight.bold,
              color: isDate ? AppColors.headingText.withOpacity(0.7) : AppColors.headingText,
            ),
          ),
          if (content.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.shipmentText,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}