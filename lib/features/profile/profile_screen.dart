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
              Navigator.pop(context);
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
          backgroundColor: AppColors.barColor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildUserProfileSettings(),
          ),
        ));
  }

  Widget _buildUserProfileSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildUserStatus(),
        const SizedBox(height: AppTheme.cardPadding),
        SettingsCard(
          onTap: () {},
          hintText: "Change password",
          iconPath: "assets/icon/lock.svg",
        ),
        const SizedBox(height: AppTheme.cardPadding),
        SettingsCard(
          onTap: () {},
          hintText: "Profile Settings",
          iconPath: "assets/icon/user.svg",
        ),
        const SizedBox(height: AppTheme.cardPadding),
        SettingsCard(
          onTap: () {},
          hintText: "Profile Settings",
          iconPath: "assets/icon/user.svg",
        ),
        const SizedBox(height: AppTheme.cardPadding),
        SettingsCard(
          onTap: () {
            _singOutUser();
          },
          hintText: "LogOut",
          backgroundColor: Colors.red,
          iconPath: "assets/icon/logout.svg",
          hintTextColor: AppColors.white,
          iconColor: AppColors.error,
        ),
        const SizedBox(height: AppTheme.cardPadding),
      ],
    );
  }

  Widget _buildUserStatus() {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return Column(
      children: [
        Container(
          width: 110, // Diameter of the avatar + border
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.blue, // Border color
              width: 1.0, // Border width
            ),
          ),
          child: CircleAvatar(
            radius: 50, // Avatar size
            backgroundImage: user != null && user.photoUrl != null
                ? NetworkImage(user.photoUrl!)
                : AssetImage('assets/images/profile.png') as ImageProvider,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user != null ? (user.displayName ?? 'Guest') : 'Guest',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.headingText),
            ),
          ],
        ),
      ],
    );
  }
}
