import 'package:quickdrop_app/core/utils/imports.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  State<ErrorPage> createState() => ErrorPageState();
}

class ErrorPageState extends State<ErrorPage> {
  bool _isLoading = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Error page',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.barColor,
        centerTitle: true,
      ),
      body: const Center(child: Text(
        "Failed to load resources please try again !",
        style: TextStyle(
          fontSize: 20,
          color: AppColors.headingText,
          
        ),
        textAlign: TextAlign.center,
      ),
    ));
  }
}
