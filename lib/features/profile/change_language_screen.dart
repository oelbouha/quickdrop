

import 'package:quickdrop_app/core/utils/imports.dart';

class ChangeLanguageScreen  extends StatefulWidget {
  const ChangeLanguageScreen ({Key? key}) : super(key: key);

  @override
  State<ChangeLanguageScreen > createState() => ChangeLanguageScreenState();
}

class ChangeLanguageScreenState extends State<ChangeLanguageScreen > {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.change_language_title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text('Change Language Screen Content Here'),
      ),
    );
  }
}