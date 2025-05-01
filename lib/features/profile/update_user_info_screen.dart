import 'package:quickdrop_app/core/utils/imports.dart';

class UpdateUserInfoScreen extends StatefulWidget {
  const UpdateUserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UpdateUserInfoScreen> createState() => UpdateUserInfoScreenState();
}

class UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  bool _isLoading = true;
  // List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
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
      body: const Center(child: Text(
        "Personal Information",
        style: TextStyle(
          fontSize: 20,
          color: AppColors.headingText,
        ),
      ),
    ));
  }
}
