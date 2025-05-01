import 'package:quickdrop_app/core/utils/imports.dart';

class ProfileStatistics extends StatefulWidget {
  const ProfileStatistics({Key? key}) : super(key: key);

  @override
  State<ProfileStatistics> createState() => ProfileStatisticsState();
}

class ProfileStatisticsState extends State<ProfileStatistics> {
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
          'Profile Statistics',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.barColor,
        centerTitle: true,
      ),
      body: const Center(child: Text(
        "Profile Statistics",
        style: TextStyle(
          fontSize: 20,
          color: AppColors.headingText,
        ),
      ),
    ));
  }
}
