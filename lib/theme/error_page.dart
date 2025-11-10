import 'package:quickdrop_app/core/utils/imports.dart';

class ErrorPage extends StatefulWidget {
  final String? errorMessage;
  const ErrorPage({Key? key, this.errorMessage}) : super(key: key);

  @override
  State<ErrorPage> createState() => ErrorPageState();
}

class ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          local.error_page_title,
          style: const TextStyle(color: AppColors.dark),
        ),
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.dark),
        centerTitle: true,
      ),
      body: Center(
        child: buildEmptyState(
          Icons.error_outline,
          local.error_occurred,
          widget.errorMessage ?? local.unexpected_error,
        ),
      ),
    );
  }
}
