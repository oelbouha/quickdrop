import 'package:quickdrop_app/core/utils/imports.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({Key? key}) : super(key: key);

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final dateController = TextEditingController();
  final weightController = TextEditingController();
  final priceController = TextEditingController();
  bool _isListButtonLoading = false;
  final _formKey = GlobalKey<FormState>();

  void _listTrip() async {
    if (_isListButtonLoading) return;
    setState(() {
      _isListButtonLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      // final userProvider = Provider.of<UserProvider>(context);
      // final user = userProvider.user;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        AppUtils.showError(context, 'Please log in to list a shipment');
        return;
      }

      Trip trip = Trip(
          from: fromController.text,
          to: toController.text,
          weight: weightController.text,
          date: dateController.text,
          userId: user.uid,
          price: priceController.text);
      try {
        await Provider.of<TripProvider>(context, listen: false).addTrip(trip);
        if (mounted) {
          Navigator.pop(context);
          AppUtils.showSuccess(context, 'Trip listed Successfully!');
           Provider.of<StatisticsProvider>(context, listen: false)
              .incrementField(user.uid, "pendingTrips");
        }
      } catch (e) {
        if (mounted) AppUtils.showError(context, 'Failed to list Trip ${e}');
      } finally {
        setState(() {
          _isListButtonLoading = false;
        });
      }
    } else {
      AppUtils.showError(context, 'some fields are empty');
    }
    setState(() {
      _isListButtonLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.appBarBackground,
          title: const Text(
            "Add your trip",
            style: TextStyle(color: AppColors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "List Your Trip",
                      style: TextStyle(
                          color: AppColors.headingText,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    const Text(
                      "Complete the form below to create a new trip",
                      style: TextStyle(color: AppColors.headingText),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildPackageDestails(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildPackageDestination(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildTimingDetails(),
                    const SizedBox(
                      height: 25,
                    ),
                    LoginButton(
                        isLoading: _isListButtonLoading,
                        hintText: "List Trip",
                        onPressed: _listTrip),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              )),
        ));
  }

  Widget _buildPackageDestails() {
    return Container(
        padding: const EdgeInsets.all(AppTheme.addShipmentPadding),
        decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.lessImportant,
                width: AppTheme.textFieldBorderWidth),
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CustomIcon(
                  iconPath: "assets/icon/map-point.svg",
                  size: 20,
                  color: AppColors.blue,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Trip Details",
                  style: TextStyle(
                      color: AppColors.headingText,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),

           TextFieldWithHeader(
              controller: priceController,
              hintText: "Available weight",
              validator: Validators.notEmpty,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWithHeader(
              controller: priceController,
              hintText: "Price",
              validator: Validators.notEmpty,
              keyboardType: TextInputType.number,
            ),
          ],
        ));
  }

 Widget _buildPackageDestination() {
    return Container(
        padding: const EdgeInsets.all(AppTheme.addShipmentPadding),
        decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.lessImportant,
                width: AppTheme.textFieldBorderWidth),
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CustomIcon(
                  iconPath: "assets/icon/map-point.svg",
                  size: 20,
                  color: AppColors.blue,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Pickup & Delivery Details",
                  style: TextStyle(
                      color: AppColors.headingText,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
           
            TextFieldWithHeader(
              controller: fromController,
              hintText: "Enter pickup location ",
              validator: Validators.notEmpty,
            ),
            const SizedBox(
              height: 10,
            ),
            
            TextFieldWithHeader(
              controller: toController,
              hintText: "Enter delivery location",
              validator: Validators.notEmpty,
            ),
          ],
        ));
  }


  Widget _buildTimingDetails() {
    return Container(
        padding: const EdgeInsets.all(AppTheme.addShipmentPadding),
        decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.lessImportant,
                width: AppTheme.textFieldBorderWidth),
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CustomIcon(
                  iconPath: "assets/icon/time.svg",
                  size: 20,
                  color: AppColors.blue,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Timing",
                  style: TextStyle(
                      color: AppColors.headingText,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            
            TextWithRequiredIcon(text: "Preferred Pickup Time"),

            DateTextField(
              controller: dateController,
              backgroundColor: AppColors.cardBackground,
              onTap: () => _selectDate(context),
              hintText: dateController.text,
              validator: Validators.notEmpty,
            ),
          ],
        ));
  }


}
