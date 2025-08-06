import 'package:quickdrop_app/core/utils/imports.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => HelpScreenState();
}

class HelpScreenState extends State<HelpScreen> {
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
          'Help',
          style: TextStyle(color: AppColors.appBarText, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.appBarBackground,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.appBarIcons),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: const Center(child: Text(
        "help page ",
        style: TextStyle(
          fontSize: 20,
          color: AppColors.headingText,
        ),
      ),
    ));
  }
}
