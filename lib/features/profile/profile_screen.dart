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
            hintText: "Confirm",
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
            style: TextStyle(color: AppColors.appBarText),
          ),
          backgroundColor: AppColors.appBarBackground,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // const SizedBox(height: AppTheme.cardPadding),
              _buildUserStatus(),
              const SizedBox(height: AppTheme.cardPadding),
              Container(
                margin: const EdgeInsets.only(
                    left: AppTheme.homeScreenPadding,
                    right: AppTheme.homeScreenPadding
                ),
                child: Column(
                  children: [
                    _buildUserProfileSettings(),
                    // const SizedBox(height: AppTheme.cardPadding),
                    const Text(
                      "Version 1.0.0 - 2025",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.headingText,
                      ),
                    ),
                    const SizedBox(height: AppTheme.cardPadding),
                  ]
              ))
            ]
        )));
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
            fontWeight: FontWeight.bold,
            color: AppColors.headingText,
          ),
        ),
        SettingsCard(
          onTap: () {},
          hintText: "Update my profile picture",
          iconPath: "assets/icon/camera-add.svg",
        ),
        SettingsCard(
          onTap: () {context.push("/profile/info");},
          hintText: "Update my personal information",
          iconPath: "assets/icon/edit-user.svg",
        ),
          SettingsCard(
          onTap: () {},
          hintText: "Notifications",
          iconPath: "assets/icon/notification.svg",
        ),
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
            fontWeight: FontWeight.bold,
            color: AppColors.headingText,
          ),
        ),
         SettingsCard(
          onTap: () {},
          hintText: "Contact suport",
          iconPath: "assets/icon/suport.svg",
        ),
         SettingsCard(
          onTap: () {},
          hintText: "Terms and Conditions",
          iconPath: "assets/icon/condition.svg",
        ),
         SettingsCard(
          onTap: () {},
          hintText: "Privacy Policy",
          iconPath: "assets/icon/privacy.svg",
        ),
          SettingsCard(
          onTap: () {},
          hintText: "Refer to your friends",
          iconPath: "assets/icon/share.svg",
        ),
         SettingsCard(
          onTap: () {},
          hintText: "Become a driver",
          iconPath: "assets/icon/driver.svg",
        ),
        SettingsCard(
          onTap: () {
            _singOutUser();
          },
          hintText: "LogOut",
          backgroundColor: Colors.red,
          iconPath: "assets/icon/logout.svg",
          hintTextColor: AppColors.headingText,
          iconColor: AppColors.error,
        ),
        const SizedBox(height: AppTheme.cardPadding),
      ],
    );
  }

  Widget _buildUserStatus() {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
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
          decoration: const BoxDecoration(color: AppColors.blue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            CircleAvatar(
            radius: 50,
            backgroundImage: user != null && user.photoUrl != null
                ? NetworkImage(user.photoUrl!)
                : AssetImage('assets/images/profile.png') as ImageProvider,
          ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user != null ? (user.displayName ?? 'Guest') : 'Guest',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white),
                ),
                const Text(
                  "Member since 2025",
                  style:  TextStyle(
                      fontSize: 14,
                      color: AppColors.lessImportant),
                ),
          ],
        ),
    ]
      )
    ));
  }
}
