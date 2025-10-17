import 'package:quickdrop_app/core/widgets/profile_image.dart';
import 'package:quickdrop_app/features/profile/settings_card.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';

String formatDate(String rawDate) {
  DateTime dateTime = DateFormat("dd/MM/yyyy").parse(rawDate);
  String formatted = DateFormat("dd MMM yyyy").format(dateTime); 
  return formatted;
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSignoutLoading = false;

  @override
  void initState() {
    super.initState();
    _precacheImages();
  }

  Future<void> _precacheImages() async {
    try {
      String? image =
          Provider.of<UserProvider>(context, listen: false).user!.photoUrl!;

      await DefaultCacheManager().downloadFile(image);
    } catch (e) {
      // print('Failed to precache image: $e');
    }
  }

  void _singOutUser() async {
    if (_isSignoutLoading) return;

    final t = AppLocalizations.of(context)!;
    setState(() {
      _isSignoutLoading = true;
    });
    final confirmed = await ConfirmationDialog.show(
      context: context,
      message: t.settings_logout_confirm_message,
      header: t.logout,
      buttonHintText: t.logout,
      iconPath: "assets/icon/logout.svg",
    );

    if (!confirmed) {
      setState(() {
        _isSignoutLoading = false;
      });
      return;
    }
    try {
      if (mounted) {
        await Provider.of<UserProvider>(context, listen: false).singOutUser();
        if (mounted) context.go("/login");
      }
    } on FirebaseException catch (e) {
      AppUtils.showDialog(context, 'Error signing out: $e', AppColors.error);
    } finally {
      setState(() {
        _isSignoutLoading = false;
      });
    }
  }

  void _showComingSoon(String feature) {
    AppUtils.showDialog(
      context,
      '$feature feature is coming soon!',
      AppColors.blue600,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        title:  Text(
          t.profile,
          style:const  TextStyle(
              color: AppColors.appBarText, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.appBarIcons),
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: _isSignoutLoading
          ? loadingAnimation()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserStats(),
                  const SizedBox(height: 32),
                  _buildQuickActions(),
                  const SizedBox(height: 32),
                  _buildSettingsSection(),
                  const SizedBox(height: 32),
                  _buildSupportSection(),
                  const SizedBox(height: 32),
                  _buildLegalSection(),
                  const SizedBox(height: 24),
                  _buildLogoutSection(),
                  const SizedBox(height: 40),
                  _buildVersionInfo(),
                ],
              ),
            ),
    );
  }

  Widget _buildUserStats() {
    final t = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

  bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (user == null) {
      return  Center(
        child: Text(
          t.no_user_data,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return GestureDetector(
        onTap: () {
          context.push(
              '/profile/statistics?userId=${user.uid}'); // Navigate to user statistics screen
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              buildProfileImage(user: user, size: 56),
              const SizedBox(width: 16),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName ?? t.guest_user,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${t.member_since} ${formatDate(user.createdAt!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ]),
              const Spacer(),
               CustomIcon(
                iconPath: isArabic ?  "assets/icon/alt-arrow-left.svg": "assets/icon/alt-arrow-right.svg",
                color: Colors.black,
                size: 20,
              ),
            ],
          ),
        ));
  }

  Widget _buildQuickActions() {
    final t = AppLocalizations.of(context)!;
    return Column(
      children: [
        _buildQuickActionItem(
          title: t.become_driver,
          subtitle: t.earn_money,
          icon: Icons.local_shipping_outlined,
          color: AppColors.blue700,
          onTap: () => {context.push("/Register-driver")},
        ),
        const SizedBox(height: 16),
        _buildQuickActionItem(
          title: t.refer_friends,
          subtitle: t.invite_friends,
          icon: Icons.card_giftcard_outlined,
          color: const Color(0xFF00A699),
          onTap: () => _showComingSoon("refer to your friend"),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(
           left: 16,
            right: 16,
            top: 12,
            bottom: 12,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.dark.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Icon(
            //   Icons.arrow_forward_ios,
            //   size: 14,
            //   color: Colors.black,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    final t = AppLocalizations.of(context)!;
    return _buildSection(
      title: t.settings,
      children: [
        settingsCard(
          title: t.personal_info,
          subtitle: t.update_details,
          iconPath: "assets/icon/edit-user.svg",
          onTap: () => context.push("/profile/info"),
        ),
        settingsCard(
          title: t.security,
          subtitle: t.manage_account,
          iconPath: "assets/icon/edit-user.svg",
          onTap: () => context.push("/profile-security"),
        ),
        settingsCard(
          title: t.notifications,
          subtitle: t.manage_notifications,
          iconPath: "assets/icon/notification.svg",
          onTap: () => _showComingSoon("notifications"),
        ),
        settingsCard(
          title: t.payment_methods,
          subtitle: t.manage_payments,
          iconPath: "assets/icon/money.svg",
          onTap: () => _showComingSoon("Payment"),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
     final t = AppLocalizations.of(context)!;
    return _buildSection(
      title: t.support,
      children: [
        settingsCard(
          title: t.get_help,
          subtitle: t.contact_support,
          iconPath: "assets/icon/suport.svg",
          onTap: () => _showComingSoon("Contact support"),
        ),
      ],
    );
  }

  Widget _buildLegalSection() {
    final t = AppLocalizations.of(context)!;
    return _buildSection(
      title: t.legal,
      children: [
        settingsCard(
          title: t.terms_service,
          subtitle: t.read_terms,
          iconPath: "assets/icon/condition.svg",
          onTap: () => context.push("/terms-of-service"),
        ),
        settingsCard(
          title: t.privacy_policy,
          subtitle: t.learn_privacy,
          iconPath: "assets/icon/privacy.svg",
          onTap: () => context.push("/privacy-policy"),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutSection() {
     final t = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // color: AppColors.error,
        // borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withValues(alpha: 0.05),
        //     blurRadius: 10,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _singOutUser,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    // color: Colors.red[50],
                    // borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.logout_outlined,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                 Expanded(
                  child: Text(
                    t.logout,
                    style:const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {

     final t = AppLocalizations.of(context)!;
    return Center(
      child: Text(
        t.version_info ,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[500],
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
