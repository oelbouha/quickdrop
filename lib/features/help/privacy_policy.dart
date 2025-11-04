import 'package:quickdrop_app/core/utils/imports.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          t.privacy_policy_title,
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
              t.privacy_last_updated,
              '',
              isDate: true,
            ),
            _buildSection(
              t.privacy_introduction_title,
              t.privacy_introduction_content,
            ),
            _buildSection(
              t.privacy_info_collect_title,
              '',
            ),
            _buildSubSection(
              t.privacy_personal_info_title,
              t.privacy_personal_info_content,
            ),
            _buildSubSection(
              t.privacy_usage_info_title,
              t.privacy_usage_info_content,
            ),
            _buildSection(
              t.privacy_how_use_title,
              t.privacy_how_use_content,
            ),
            _buildSection(
              t.privacy_info_sharing_title,
              t.privacy_info_sharing_content,
            ),
            _buildSection(
              t.privacy_data_security_title,
              t.privacy_data_security_content,
            ),
            _buildSection(
              t.privacy_data_retention_title,
              t.privacy_data_retention_content,
            ),
            _buildSection(
              t.privacy_your_rights_title,
              t.privacy_your_rights_content,
            ),
            _buildSection(
              t.privacy_children_title,
              t.privacy_children_content,
            ),
            _buildSection(
              t.privacy_international_title,
              t.privacy_international_content,
            ),
            _buildSection(
              t.privacy_third_party_title,
              t.privacy_third_party_content,
            ),
            _buildSection(
              t.privacy_changes_title,
              t.privacy_changes_content,
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

  Widget _buildSubSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.headingText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.shipmentText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}