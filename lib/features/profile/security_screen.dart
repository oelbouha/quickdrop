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

  

  Future<void> deleteAccount() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    final confirmed =  await ConfirmationDialog.show(
        context: context,
        message: 'Are you sure you want to delete your Account?',
        header: 'Delete account',
        buttonHintText: 'Confirm',
        buttonColor: AppColors.error,
        iconColor: AppColors.error,
        iconData: Icons.delete,
      );
    if (!confirmed){
       setState(() {
      _isLoading = false;
    });
    return ;
    }
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await Provider.of<ShipmentProvider>(context, listen: false)
          .deleteShipmentsByUserId(userId);
      await Provider.of<TripProvider>(context, listen: false)
          .deleteTripsByUserId(userId);
      // await Provider.of<UserProvider>(context, listen: false)
      //     .deleteUser(userId);
      if (mounted) {
        await showSuccessAnimation(context,
          title: "Account deleted Successfully!",
          message: "Your sccount and data has been deleted Successfully."
        );
      }
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
      body: _isLoading
    ? const Center(
        child: CircularProgressIndicator(
          color: AppColors.blue700,
          strokeWidth: 3,
        ),
      )
    : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
          child: _buildUpdateScreen(),
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
