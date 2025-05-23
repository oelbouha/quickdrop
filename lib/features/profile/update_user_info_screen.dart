import 'package:quickdrop_app/core/utils/imports.dart';

class UpdateUserInfoScreen extends StatefulWidget {
  const UpdateUserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UpdateUserInfoScreen> createState() => UpdateUserInfoScreenState();
}

class UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  bool _isLoading = false;
  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserData? user;
  // List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
    emailController.text = user?.email ?? "Email";
    firstNameController.text = user?.firstName ?? "First Name";
    lastNameController.text = user?.lastName ?? "Last Name";
    phoneNumberController.text = user?.phoneNumber ?? "Phone Number";
  }

  void updateInfo() async {
    if (_isLoading) return;

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final user = Provider.of<UserProvider>(context, listen: false).user;
        UserData updatedUser = UserData(
          uid: user!.uid,
          displayName: '${firstNameController.text} ${lastNameController.text}',
          email: emailController.text,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          phoneNumber: phoneNumberController.text,

        );
        await Provider.of<UserProvider>(context, listen: false)
            .updateUserInfo(updatedUser);
        if (mounted) {
          AppUtils.showSuccess(context, "Information updated succesfully!");
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          AppUtils.showError(
              context, "Failed to update information try again !");
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'personal information',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.barColor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(child:  Padding(
            padding: const EdgeInsets.all(16), child: _buildUpdateScreen())));
  }

  Widget _buildUpdateScreen() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "First name",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            CustomTextField(
              controller: firstNameController,
              hintText: firstNameController.text,
              backgroundColor: AppColors.cardBackground,
              validator: Validators.name,
            ),
            const SizedBox(
              height: 15,
            ),
             const Text(
              "Last name",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            CustomTextField(
              controller: lastNameController,
              hintText: lastNameController.text,
              backgroundColor: AppColors.cardBackground,
              validator: Validators.name,
            ),
            const SizedBox(
              height: 15,
            ),
             const Text(
              "Phone number",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            CustomTextField(
              controller: phoneNumberController,
              hintText: phoneNumberController.text,
              backgroundColor: AppColors.cardBackground,
              validator: Validators.name,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Email",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            CustomTextField(
              controller: emailController,
              hintText: emailController.text,
              backgroundColor: AppColors.cardBackground,
              validator: Validators.email,
            ),
            const SizedBox(
              height: 20,
            ),
            LoginButton(
                isLoading: _isLoading,
                hintText: "Save changes",
                onPressed: updateInfo),
            const SizedBox(
              height: 25,
            ),
          ],
        ));
  }
}
