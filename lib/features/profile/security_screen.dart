
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/features/profile/settings_card.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => SecurityScreenState();
}

class SecurityScreenState extends State<SecurityScreen> {
  bool _isLoading = false;
  UserData? user;

  Future<void> deleteAccount() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    final confirmed =  await ConfirmationDialog.show(
        context: context,
        message: AppLocalizations.of(context)!.security_delete_account_confirm,
        header: AppLocalizations.of(context)!.security_delete_account_title,
        buttonHintText: AppLocalizations.of(context)!.security_confirm_button,
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
      await Provider.of<StatisticsProvider>(context, listen: false).deleteStatistics(userId);
      await Provider.of<UserProvider>(context, listen: false)
          .deleteUser(userId);
      await FirebaseAuth.instance.currentUser!.delete();
      if (mounted) {
        await showSuccessAnimation(context,
          title: AppLocalizations.of(context)!.security_delete_success_title,
          message: AppLocalizations.of(context)!.security_delete_success_message
        );
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.security_profile_settings_title,
          style: const TextStyle(
            color: AppColors.appBarText,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.appBarBackground,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
    ? loadingAnimation()
    : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
        child: _buildUpdateScreen(),
      ),
    );
  }

  Widget _buildUpdateScreen() {
    return Container(
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        settingsCard(
          title: AppLocalizations.of(context)!.security_delete_account_title,
          subtitle: AppLocalizations.of(context)!.security_delete_account_subtitle,
          iconPath: "assets/icon/trash-bin.svg",
          onTap: () => deleteAccount(),
        ),
         settingsCard(
          title: AppLocalizations.of(context)!.settings_language,
          subtitle: AppLocalizations.of(context)!.security_change_language_subtitle,
          iconPath: "assets/icon/lang.svg",
          onTap: () => {context.push('/change-language')},
        ),
      ],
    ));
  }
}