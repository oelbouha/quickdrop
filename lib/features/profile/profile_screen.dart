import 'package:quickdrop_app/features/profile/settings_card.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  bool _isSignoutLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _singOutUser() async {
      final confirmed = await ConfirmationDialog.show(
        context: context,
        message: 'Are you sure you want to log out?',
        header: 'Log Out',
        buttonHintText: 'Log Out',
        iconData: Icons.delete_outline,
      );
      
      if (!confirmed) return; 

      try {
        // AppUtils.showLoading(context);
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          Provider.of<UserProvider>(context, listen: false).clearUser();
          context.go("/login");
        }
      } on FirebaseException catch (e) {
        AppUtils.showDialog(
            context, 'Error signing out: $e', AppColors.error);
      } finally {
        setState(() {
          _isSignoutLoading = false;
        });
      }
          
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
          elevation: 0,
        ),
        body: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                ]))));
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  void _showComingSoon(String feature) {
    AppUtils.showDialog(
      context,
      '$feature feature is coming soon!',
      AppColors.blue600,
    );
  }

  Widget _buildUserProfileSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Profile Settings"),
        const SizedBox(height: 12),
        Container(
          //  color: AppColors.white,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              SettingsCard(
                onTap: () {
                  _showComingSoon("update image");
                },
                hintText: "Update my profile picture",
                iconPath: "assets/icon/camera-add.svg",
              ),
              Divider(
                  height: 1,
                  color: Colors.grey[200],
                  indent: 40,
                ),
              // const SizedBox(height: 6),
              SettingsCard(
                onTap: () {
                  context.push("/profile/info");
                },
                hintText: "Update my personal information",
                iconPath: "assets/icon/edit-user.svg",
              ),
              Divider(
                  height: 1,
                  color: Colors.grey[200],
                  indent: 40,
                ),
              // const SizedBox(height: 6),
              SettingsCard(
                onTap: () {_showComingSoon("notifications");},
                hintText: "Notifications",
                iconPath: "assets/icon/notification.svg",
              ),
              Divider(
                  height: 1,
                  color: Colors.grey[200],
                  indent: 40,
                ),
              // const SizedBox(height: 6),
              SettingsCard(
                onTap: () {_showComingSoon("Payment");},
                hintText: "Payment methods",
                iconPath: "assets/icon/money.svg",
              ),
             
            ],
          ),
        ),
        const SizedBox(height: AppTheme.cardPadding * 1.5),
        _buildSectionHeader("Resouces"),
        const SizedBox(
          height: 12,
        ),
        Container(
            decoration: BoxDecoration(
               color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            ),
            child: Column(children: [
              SettingsCard(
                onTap: () {_showComingSoon("Contact support");},
                hintText: "Contact support",
                iconPath: "assets/icon/suport.svg",
              ),
              Divider(
                  height: 1,
                  color: Colors.grey[200],
                  indent: 40,
                ),
              SettingsCard(
                onTap: () {
                  context.push("/terms-of-service");
                },
                hintText: "Terms and Conditions",
                iconPath: "assets/icon/condition.svg",
              ),
              Divider(
                  height: 1,
                  color: Colors.grey[200],
                  indent: 40,
                ),
              SettingsCard(
                onTap: () {
                  context.push("/privacy-policy");
                },
                hintText: "Privacy Policy",
                iconPath: "assets/icon/privacy.svg",
              ),
              Divider(
                  height: 1,
                  color: Colors.grey[200],
                  indent: 40,
                ),
              SettingsCard(
                onTap: () {_showComingSoon("refer to your friend");},
                hintText: "Refer to your friends",
                iconPath: "assets/icon/share.svg",
              ),
              Divider(
                  height: 1,
                  color: Colors.grey[200],
                  indent: 40,
                ),
            ])),
        const SizedBox(height: 20),
        SettingsCard(
          onTap: () {_showComingSoon("driver registration");},
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

  Widget _buildStatsPreview() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.analytics_outlined,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          const Text(
            'View Statistics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.8),
            size: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatus() {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    // print("photo ${user!.photoUrl}");
    return GestureDetector(
        onTap: () {
          context.push('/profile/statistics?userId=${user!.uid}');
        },
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              left: AppTheme.cardPadding,
              right: AppTheme.cardPadding,
              top: AppTheme.cardPadding * 2,
              bottom: AppTheme.cardPadding * 2,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.blueStart, AppColors.purpleEnd],
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProfileImage(user),
                  const SizedBox(width: 15),
                  _buildUserInfo(user),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildStatsPreview(),
                ])));
  }

  Widget _buildUserInfo(user) {
    return Column(
      children: [
        Text(
          user?.displayName ?? 'Guest',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Member since ${user?.createdAt ?? 'N/A'}",
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.lessImportant,
          ),
        ),
      ],
    );
  }
      Widget _buildProfileImage(user) {
    return Stack(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(55),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(55),
            child:  Image.network(
                    user?.photoUrl ?? AppTheme.defaultProfileImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.white.withOpacity(0.1),
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
    );
  }
}