import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/core/widgets/profile_avatar.dart';
import 'package:quickdrop_app/features/profile/settings_card.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

class ChangePersonalInfoScreen extends StatefulWidget {
  const ChangePersonalInfoScreen({Key? key}) : super(key: key);

  @override
  State<ChangePersonalInfoScreen> createState() =>
      ChangePersonalInfoScreenState();
}

class ChangePersonalInfoScreenState extends State<ChangePersonalInfoScreen> {
  bool _isLoading = false;
  UserData? user;

  String? _oldName;
  String? _oldLastName;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    user = Provider.of<UserProvider>(context, listen: false).user;
    _initializeFields();
  }

  void _initializeFields() {
    firstNameController.text = user?.firstName ?? "";
    lastNameController.text = user?.lastName ?? "";
    _oldName = user?.firstName ?? "";
    _oldLastName = user?.lastName ?? "";
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Future<void> updateInfo() async {
    final t = AppLocalizations.of(context)!;
    if (_isLoading) return;

    if (_formKey.currentState!.validate() == false) {
      return;
    }
    if (_oldLastName == lastNameController.text.trim() &&
        _oldName == firstNameController.text.trim()) {
      AppUtils.showDialog(
        context,
        t.no_changes_detected,
        AppColors.error,
      );
      return;
    }

    final confirmed = await ConfirmationDialog.show(
      context: context,
      message: t.save_changes_message,
      header: t.save_changes,
      buttonHintText: t.save_button_text,
      buttonColor: AppColors.blue700,
      iconColor: AppColors.blue700,
      iconData: Icons.save,
    );
    
    if (!confirmed) return;

    setState(() => _isLoading = true);

    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;

      UserData updatedUser = UserData(
        uid: user!.uid,
        displayName:
            '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
      );

      await Provider.of<UserProvider>(context, listen: false)
          .updateUserInfo(updatedUser);

      if (mounted) {
        await showSuccessAnimation(context,
            title: t.update_success_title, message: t.update_success_message);
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showDialog(context, t.update_error_message, AppColors.error);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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

  Widget _buildHeaderSection() {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue.withOpacity(0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.update_profile,
                      style: const TextStyle(
                        color: AppColors.headingText,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.update_profile_subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateScreen() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 32),
          _buildPersonalInfoSection(),
          const SizedBox(height: 24),
          IconTextButton(
            isLoading: _isLoading,
            onPressed: updateInfo,
            iconPath: "assets/icon/save.svg",
             hint: AppLocalizations.of(context)!.save_button_text,
            loadingText: AppLocalizations.of(context)!.saving,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    final t = AppLocalizations.of(context)!;
    return ProfileSectionCard(
      title: t.personal_info,
      icon: Icons.badge_outlined,
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: firstNameController,
                label: t.first_name,
                hintText: t.enter_first_name,
                iconPath: "assets/icon/user.svg",
                validator: Validators.name(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                controller: lastNameController,
                label: t.last_name,
                hintText: t.enter_last_name,
                iconPath: "assets/icon/user.svg",
                validator: Validators.name(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StatusCard(
          icon: Icons.info_outline,
          title: t.important,
          message: t.personal_info_note,
          color: Colors.blue,
        ),
      ],
    );
  }
}
