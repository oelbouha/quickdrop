import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/features/profile/settings_card.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/profile_image.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => SecurityScreenState();
}

class SecurityScreenState extends State<SecurityScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;

  UserData? user;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _showSuccessAnimation() async {
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(dialogContext).pop();
            Navigator.of(context).pop();
          }
        });
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 64 * value,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Account deleted Successfully!',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your sccount and data has been deleted Successfully.',
                style:
                    const TextStyle(fontSize: 14, color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> deleteAccount() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await Provider.of<ShipmentProvider>(context, listen: false)
          .deleteShipmentsByUserId(userId);
      await Provider.of<TripProvider>(context, listen: false)
          .deleteTripsByUserId(userId);
      // await Provider.of<UserProvider>(context, listen: false)
      //     .deleteUser(userId);
      _showSuccessAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profile Settings',
          style: TextStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _isLoading
              ? const Center(child:CircularProgressIndicator(
                  color: AppColors.blue700,
                  strokeWidth: 3,
                ))
              : _buildUpdateScreen(),
        ),
      ),
    );
  }

  Widget _buildUpdateScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        settingsCard(
          title: "Delete Account",
          subtitle: "delete your account",
          iconPath: "assets/icon/trash-bin.svg",
          onTap: () => deleteAccount(),
        ),
      ],
    );
  }
}
