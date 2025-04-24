import 'dart:io'; // Import File class
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/dropDownTextField.dart';

class AddShipmentScreen extends StatefulWidget {
  const AddShipmentScreen({Key? key}) : super(key: key);

  @override
  State<AddShipmentScreen> createState() => _AddShipmentScreenState();
}

class _AddShipmentScreenState extends State<AddShipmentScreen> {
  File? _selectedImage;
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final weightController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final packageNameController = TextEditingController();
  final packageQuantityController = TextEditingController();
  final typeController = TextEditingController();
  final priceController = TextEditingController();
  bool _isListButtonLoading = false;
  final _formKey = GlobalKey<FormState>();

  void _listShipment() async {
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

      Shipment shipment = Shipment(
        price: priceController.text,
        type: typeController.text,
        from: fromController.text,
        to: toController.text,
        weight: weightController.text,
        description: descriptionController.text,
        date: dateController.text,
        length: lengthController.text,
        width: widthController.text,
        height: heightController.text,
        packageName: packageNameController.text,
        packageQuantity: packageQuantityController.text,
        imageUrl: null, // Add image upload logic if needed
        userId: user.uid,
      );
      try {
        await Provider.of<ShipmentProvider>(context, listen: false)
            .addShipment(shipment);
        if (mounted) {
          Navigator.pop(context);
          AppUtils.showSuccess(context, 'Shipment listed Successfully!');
        }
      } catch (e) {
        if (mounted) AppUtils.showError(context, 'Failed to list shipment ${e}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.barColor,
          title: const Text(
            "Add your Shipment",
            style: TextStyle(
                color: AppColors.headingText,
                fontWeight: FontWeight.bold,
                fontSize: 18),
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
                        "List Your Package",
                        style: TextStyle(
                            color: AppColors.headingText,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      const Text(
                        "Complete the form below to create a new delivery request",
                        style: TextStyle(color: AppColors.headingText),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      _buildPackageDetails(),
                      const SizedBox(
                        height: 25,
                      ),
                      _buildPackageDestination(),
                      const SizedBox(
                        height: 25,
                      ),
                      _buildTimingDetails(),
                      const SizedBox(
                        height: 25,
                      ),
                      LoginButton(
                          hintText: "List Package",
                          onPressed: _listShipment,
                          isLoading: _isListButtonLoading),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ))));
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickerFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickerFile != null) {
      setState(() {
        _selectedImage = File(pickerFile.path);
      });
    }
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

  Widget _buildPackageDetails() {
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
                  iconPath: "assets/icon/package.svg",
                  size: 20,
                  color: AppColors.blue,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Package details",
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
            const Text(
              "Package name",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            CustomTextField(
              controller: packageNameController,
              hintText: "Name",
              backgroundColor: AppColors.cardBackground,
              validator: Validators.notEmpty,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Package description",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            CustomTextField(
              controller: descriptionController,
              hintText: "Describe your package content",
              backgroundColor: AppColors.cardBackground,
              maxLines: 3,
              validator: Validators.notEmpty,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Weight (kg)",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            NumberField(
              controller: weightController,
              hintText: "Weight",
              backgroundColor: AppColors.cardBackground,
              validator: Validators.notEmpty,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Quantity",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            NumberField(
              controller: packageQuantityController,
              hintText: "Quantity",
              backgroundColor: AppColors.cardBackground,
              validator: Validators.notEmpty,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Price",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            NumberField(
              controller: priceController,
              hintText: "Price",
              backgroundColor: AppColors.cardBackground,
              validator: Validators.notEmpty,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Type",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            DropdownTextField(
              validator: Validators.notEmpty,
              controller: typeController,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Demensions (cm)",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              children: [
                Expanded(
                  child: NumberField(
                    controller: lengthController,
                    hintText: "Length",
                    backgroundColor: AppColors.cardBackground,
                  ),
                ),
                const SizedBox(width: 8), // Add spacing between inputs
                Expanded(
                  child: NumberField(
                    controller: widthController,
                    hintText: "Width",
                    backgroundColor: AppColors.cardBackground,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: NumberField(
                    controller: heightController,
                    hintText: "Height",
                    backgroundColor: AppColors.cardBackground,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Package image",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            ImageUpload(
              onPressed: _pickImage,
              backgroundColor: AppColors.cardBackground,
              controller: dateController,
              hintText: "",
            )
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
            const Text(
              "Pickup Address",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            CustomTextField(
              controller: fromController,
              hintText: "Enter pickup location ",
              backgroundColor: AppColors.cardBackground,
              validator: Validators.notEmpty,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Dropoff Address",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            CustomTextField(
              controller: toController,
              hintText: "Enter delivery location",
              backgroundColor: AppColors.cardBackground,
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
            const Text(
              "Preferred Pickup Time",
              style: TextStyle(
                  color: AppColors.headingText, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
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
