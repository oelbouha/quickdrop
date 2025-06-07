import 'package:quickdrop_app/features/profile/settings_card.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSignoutLoading = false;

  void _singOutUser() async {
    showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
            message: "Are you sure you want to log out",
            buttonHintText: "Confirm",
            iconPath: "assets/icon/logout.svg",
            header: "Log Out",
            onPressed: () async {
              // Navigator.pop(context);
              if (_isSignoutLoading) return;
              setState(() {
                _isSignoutLoading = true;
              });
              try {
                AppUtils.showLoading(context);
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Provider.of<UserProvider>(context, listen: false).clearUser();
                  context.go("/login");
                }
              } on FirebaseException catch (e) {
                AppUtils.showError(context, 'Error signing out: $e');
              } finally {
                setState(() {
                  _isSignoutLoading = false;
                });
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(color: AppColors.white),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.blueStart, AppColors.purpleEnd],
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          _buildUserStatus(),
          const SizedBox(height: AppTheme.cardPadding),
          Container(
              margin: const EdgeInsets.only(
                  left: AppTheme.homeScreenPadding,
                  right: AppTheme.homeScreenPadding),
              child: Column(children: [
                _buildUserProfileSettings(),
                const SizedBox(height: AppTheme.cardPadding),
                const Text(
                  "Version 1.0.0 - 2025",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightGray,
                  ),
                ),
                const SizedBox(height: AppTheme.cardPadding),
              ]))
        ])));
  }

  Widget _buildUserProfileSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Profile Settings",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        SettingsCard(
          onTap: () {},
          hintText: "Update my profile picture",
          iconPath: "assets/icon/camera-add.svg",
        ),
        const SizedBox(height: 6),
        SettingsCard(
          onTap: () {
            context.push("/profile/info");
          },
          hintText: "Update my personal information",
          iconPath: "assets/icon/edit-user.svg",
        ),
        const SizedBox(height: 6),
        SettingsCard(
          onTap: () {},
          hintText: "Notifications",
          iconPath: "assets/icon/notification.svg",
        ),
        const SizedBox(height: 6),
        SettingsCard(
          onTap: () {},
          hintText: "Payment methods",
          iconPath: "assets/icon/money.svg",
        ),
        
        const SizedBox(height: AppTheme.cardPadding),
        const Text(
          "Resources",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        SettingsCard(
          onTap: () {},
          hintText: "Contact suport",
          iconPath: "assets/icon/suport.svg",
        ),
        const SizedBox(height: 6),
        SettingsCard(
          onTap: () {},
          hintText: "Terms and Conditions",
          iconPath: "assets/icon/condition.svg",
        ),
        const SizedBox(height: 6),
        SettingsCard(
          onTap: () {},
          hintText: "Privacy Policy",
          iconPath: "assets/icon/privacy.svg",
        ),
        const SizedBox(height: 6),
        SettingsCard(
          onTap: () {},
          hintText: "Refer to your friends",
          iconPath: "assets/icon/share.svg",
        ),
        const SizedBox(height: 6),
        SettingsCard(
          onTap: () {},
          hintText: "Become a driver",
          iconPath: "assets/icon/driver.svg",
          backgroundColor: AppColors.blueStart,
          hintTextColor: AppColors.white,
          iconColor: AppColors.white,
        ),
        const SizedBox(height: 6),
        SettingsCard(
          onTap: () {
            _singOutUser();
          },
          hintText: "LogOut",
          backgroundColor: Colors.red,
          iconPath: "assets/icon/logout.svg",
          hintTextColor: AppColors.white,
          iconColor: AppColors.white,
        ),
        const SizedBox(height: AppTheme.cardPadding),
      ],
    );
  }

  Widget _buildUserStatus() {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    // print("photo ${user!.photoUrl}");
    return GestureDetector(
        onTap: () {
          context.push("/profile/statistics");
        },
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              left: AppTheme.cardPadding,
              right: AppTheme.cardPadding,
              top: AppTheme.cardPadding,
              bottom: AppTheme.cardPadding,
            ),
            decoration: const BoxDecoration(
              gradient:  LinearGradient(
                colors: [AppColors.blueStart, AppColors.purpleEnd],
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
                  width: 3,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: Image.network(
                  user?.photoUrl ?? AppTheme.defaultProfileImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.white,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(user?.displayName ?? 'Guest',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white),
                      ),
                       Text(
                       "Member since ${user?.createdAt!}",
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.lessImportant),
                      ),
                    ],
                  ),
                ])));
  }



}
