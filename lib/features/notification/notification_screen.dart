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
          style: TextStyle(color: AppColors.appBarText, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.appBarBackground,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.appBarIcons),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Center(child: buildEmptyState(
          Icons.notification_important_outlined,
          'No Notifications',
          'You have no notifications',
        ))  
    );
  }
}
