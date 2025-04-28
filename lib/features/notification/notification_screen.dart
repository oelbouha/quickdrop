import 'package:quickdrop_app/core/utils/imports.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
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
          'Notifications',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.barColor,
        centerTitle: true,
      ),
      body: const Center(child: Text(
        "No Notifications",
        style: TextStyle(
          fontSize: 20,
          color: AppColors.headingText,
        ),
      ),
    ));
  }
}
