import 'package:quickdrop_app/core/utils/imports.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'Terms of Service',
          style: TextStyle(color: AppColors.appBarText, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.appBarBackground,
        centerTitle: true,

        iconTheme: const IconThemeData(color: AppColors.appBarIcons),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
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
              '1. Acceptance of Terms',
              'By accessing and using QuickDrop ("the App", "our Service"), you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
            ),
            _buildSection(
              '2. Description of Service',
              'QuickDrop is a peer-to-peer package delivery platform that connects users who need packages delivered ("Senders") with users willing to deliver packages ("Carriers"). Our platform facilitates these connections but does not directly provide delivery services.',
            ),
            _buildSection(
              '3. User Responsibilities',
              'Senders are responsible for:\n'
              '• Accurately describing package contents and dimensions\n'
              '• Ensuring packages comply with local laws and regulations\n'
              '• Proper packaging to prevent damage during transport\n'
              '• Providing accurate pickup and delivery addresses\n'
              '• Paying agreed-upon delivery fees\n\n'
              'Carriers are responsible for:\n'
              '• Safe and timely delivery of packages\n'
              '• Treating packages with reasonable care\n'
              '• Following delivery instructions\n'
              '• Maintaining valid identification and transportation\n'
              '• Reporting any issues or delays promptly',
            ),
            _buildSection(
              '4. Prohibited Items',
              'The following items are strictly prohibited on our platform:\n'
              '• Illegal substances or contraband\n'
              '• Hazardous materials (explosives, chemicals, etc.)\n'
              '• Weapons or ammunition\n'
              '• Live animals\n'
              '• Perishable food items without proper packaging\n'
              '• Items exceeding weight/size limits specified in the app\n'
              '• Cash or negotiable instruments\n'
              '• Items that violate intellectual property rights',
            ),
            _buildSection(
              '5. Payment and Fees',
              'Payment processing is handled through our secure payment system. Delivery fees are determined by distance, package size, and urgency. QuickDrop retains a service fee from each transaction. Refunds may be available in cases of non-delivery or service failure, subject to our refund policy.',
            ),
            _buildSection(
              '6. Liability and Insurance',
              'QuickDrop acts as a platform connecting users and is not liable for:\n'
              '• Loss, damage, or theft of packages\n'
              '• Delays in delivery\n'
              '• Actions or negligence of users\n'
              '• Content or condition of packages\n\n'
              'Users are encouraged to purchase insurance for valuable items. Our liability is limited to the maximum extent permitted by law.',
            ),
            _buildSection(
              '7. User Conduct',
              'Users must:\n'
              '• Provide accurate and truthful information\n'
              '• Respect other users and maintain professional conduct\n'
              '• Not use the service for illegal activities\n'
              '• Not attempt to circumvent the platform for direct transactions\n'
              '• Report suspicious activities or policy violations',
            ),
            _buildSection(
              '8. Account Termination',
              'We reserve the right to suspend or terminate accounts for violations of these terms, suspicious activity, or other reasons at our sole discretion. Users may close their accounts at any time through the app settings.',
            ),
            _buildSection(
              '9. Privacy',
              'Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and protect your information.',
            ),
            _buildSection(
              '10. Modifications',
              'We reserve the right to modify these terms at any time. Users will be notified of significant changes through the app or email. Continued use after modifications constitutes acceptance of the new terms.',
            ),
            _buildSection(
              '11. Governing Law',
              'These terms are governed by the laws of [YOUR JURISDICTION]. Any disputes will be resolved through binding arbitration or in courts of [YOUR JURISDICTION].',
            ),
            _buildSection(
              '12. Contact Information',
              'For questions about these Terms of Service, contact us at:\n'
              'Email: legal@quickdrop.com\n'
              'Address: address',
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