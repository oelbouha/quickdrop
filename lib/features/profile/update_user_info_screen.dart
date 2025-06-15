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
          AppUtils.showDialog(
              context, "Information updated succesfully!", AppColors.succes);
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          AppUtils.showDialog(context,
              "Failed to update information try again !", AppColors.error);
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          // title: const Text(
          //   'personal information',
          //   style: TextStyle(color: AppColors.dark),
          // ),
          backgroundColor: AppColors.white,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black, // Set the arrow back color to black
          ),
          systemOverlayStyle:
              SystemUiOverlayStyle.dark, // Ensures status bar icons are dark
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildUpdateScreen())));
  }

  Widget _buildUpdateScreen() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Update your information",
              style: TextStyle(
                  color: AppColors.headingText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldWithHeader(
              controller: firstNameController,
              headerText: 'Full Name',
              hintText: 'First name on ID',
              obsecureText: false,
              iconPath: "assets/icon/user.svg",
              isRequired: false,
              validator: Validators.name,
            ),
            const SizedBox(height: 8),
            TextFieldWithoutHeader(
              controller: lastNameController,
              hintText: 'Last name on ID',
              obsecureText: false,
              validator: Validators.name,
            ),
            const SizedBox(height: 6),
            TipWidget(message: "Make sure this matches the name on your government ID or passport."),
            const SizedBox(height: 30),
            TextFieldWithHeader(
              controller: emailController,
              hintText: 'example@gmail.com',
              isRequired: false,
              headerText: 'Email',
              obsecureText: false,
              iconPath: "assets/icon/email.svg",
              validator: Validators.email,
            ),
            const SizedBox(height: 30),
            TextFieldWithHeader(
              controller: phoneNumberController,
              hintText: '06 000 00 00',
              isRequired: false,
              headerText: 'Phone number',
              obsecureText: false,
              iconPath: "assets/icon/email.svg",
              validator: Validators.phone,
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
