import 'package:quickdrop_app/core/utils/imports.dart';

class UpdateUserInfoScreen extends StatefulWidget {
  const UpdateUserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UpdateUserInfoScreen> createState() => UpdateUserInfoScreenState();
}

class UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  bool _isLoading = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserData? user;
  // List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
    emailController.text = user?.email ?? "Email";
    nameController.text = user?.displayName ?? "Name";
  }

  void updateInfo() async {
    if (_isLoading) return;

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final user = Provider.of<UserProvider>(context, listen: false).user;
        UserData updatedUser = UserData(
          uid: user!.uid,
          displayName: nameController.text,
          email: emailController.text,
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
        body: Padding(
            padding: const EdgeInsets.all(16), child: _buildUpdateScreen()));
  }

  Widget _buildUpdateScreen() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Name",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            CustomTextField(
              controller: nameController,
              hintText: nameController.text,
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
