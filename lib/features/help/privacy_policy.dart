import 'package:quickdrop_app/core/utils/imports.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: AppBarText(
          text: 'Privacy Policy',
        ),
        backgroundColor: AppColors.barColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Last Updated: 2025-24-5',
              '',
              isDate: true,
            ),
            _buildSection(
              'Introduction',
              'QuickDrop ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our peer-to-peer package delivery mobile application.',
            ),
            _buildSection(
              '1. Information We Collect',
              '',
            ),
            _buildSubSection(
              'Personal Information:',
              '• Name and contact information (email, phone number)\n'
              '• Profile photo and identification documents\n'
              '• Payment information (processed securely through third parties)\n'
              '• Delivery addresses and location data\n'
              '• Device information and unique identifiers',
            ),
            _buildSubSection(
              'Usage Information:',
              '• App usage patterns and preferences\n'
              '• Delivery history and transaction records\n'
              '• Communication between users (for safety and quality purposes)\n'
              '• Ratings and reviews\n'
              '• GPS location data during active deliveries',
            ),
            _buildSubSection(
              'Technical Information:',
              '• Device type, operating system, and app version\n'
              '• IP address and network information\n'
              '• Crash reports and performance data\n'
              '• Cookies and similar tracking technologies',
            ),
            _buildSection(
              '2. How We Use Your Information',
              'We use your information to:\n'
              '• Facilitate package deliveries and connect users\n'
              '• Process payments and maintain transaction records\n'
              '• Verify user identity and ensure platform safety\n'
              '• Provide customer support and resolve disputes\n'
              '• Improve our services and develop new features\n'
              '• Send important notifications about your deliveries\n'
              '• Comply with legal requirements and prevent fraud\n'
              '• Analyze usage patterns to enhance user experience',
            ),
            _buildSection(
              '3. Information Sharing',
              'We share your information only in these circumstances:\n'
              '• With other users as necessary for delivery coordination\n'
              '• With payment processors for transaction processing\n'
              '• With service providers who assist our operations\n'
              '• When required by law or legal process\n'
              '• To protect our rights and prevent illegal activities\n'
              '• In case of business transfer or merger (with user notification)\n\n'
              'We never sell your personal information to third parties.',
            ),
            _buildSection(
              '4. Location Data',
              'We collect location data to:\n'
              '• Match senders with nearby carriers\n'
              '• Provide real-time delivery tracking\n'
              '• Calculate delivery distances and fees\n'
              '• Ensure deliveries are completed successfully\n\n'
              'Location tracking is only active during delivery processes and can be disabled in your device settings, though this may limit app functionality.',
            ),
            _buildSection(
              '5. Data Security',
              'We implement industry-standard security measures including:\n'
              '• Encryption of data in transit and at rest\n'
              '• Secure authentication and access controls\n'
              '• Regular security audits and updates\n'
              '• Limited access to personal information by employees\n'
              '• Secure payment processing through certified providers\n\n'
              'However, no method of transmission over the Internet is 100% secure.',
            ),
            _buildSection(
              '6. Data Retention',
              'We retain your information for as long as:\n'
              '• Your account is active\n'
              '• Needed to provide our services\n'
              '• Required by law or for legal proceedings\n'
              '• Necessary for safety and fraud prevention\n\n'
              'You can request account deletion at any time, though some information may be retained for legal compliance.',
            ),
            _buildSection(
              '7. Your Rights and Choices',
              'You have the right to:\n'
              '• Access and review your personal information\n'
              '• Correct inaccurate or incomplete data\n'
              '• Delete your account and associated data\n'
              '• Opt out of marketing communications\n'
              '• Request a copy of your data\n'
              '• Withdraw consent where applicable\n\n'
              'To exercise these rights, contact us through the app or email.',
            ),
            _buildSection(
              '8. Children\'s Privacy',
              'Our service is not intended for users under 18 years of age. We do not knowingly collect personal information from children under 18. If we become aware of such collection, we will delete the information immediately.',
            ),
            _buildSection(
              '9. International Data Transfers',
              'Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place to protect your data in accordance with this Privacy Policy.',
            ),
            _buildSection(
              '10. Third-Party Services',
              'Our app may contain links to third-party services or integrate with external platforms. This Privacy Policy does not cover third-party practices. Please review their privacy policies separately.',
            ),
            _buildSection(
              '11. Changes to This Policy',
              'We may update this Privacy Policy periodically. We will notify users of significant changes through the app or email. Your continued use after changes indicates acceptance of the updated policy.',
            ),
            _buildSection(
              '12. Contact Us',
              'For questions about this Privacy Policy or data practices, contact us at:\n'
              'Email: privacy@quickdrop.com\n'
              'Address: address\n'
              'Phone: phone number',
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