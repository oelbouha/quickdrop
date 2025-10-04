

import 'package:quickdrop_app/core/utils/imports.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  UserData? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        title: const Text(
          'Payment Methods',
          style: TextStyle(color: AppColors.appBarText, fontWeight: FontWeight.w600),
          
        ),
        centerTitle: true,
      ),
      body: Text("Payment Methods coming soon..."),
    );
  }
}