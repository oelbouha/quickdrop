import 'package:quickdrop_app/core/utils/imports.dart';

class ErrorPage extends StatefulWidget {
  final String? errorMessage;
  const ErrorPage({Key? key, this.errorMessage}) : super(key: key);

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
      body: Center(child: Text(
       widget.errorMessage ?? "Failed to load resources please try again !",
        style: const TextStyle(
          fontSize: 20,
          color: AppColors.headingText,
          
        ),
        textAlign: TextAlign.center,
      ),
    ));
  }
}
