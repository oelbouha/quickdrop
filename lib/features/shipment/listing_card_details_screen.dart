import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';

class ListingCardDetails extends StatefulWidget {
  final Shipment shipment;
  final UserData user;

  const ListingCardDetails(
      {super.key, required this.shipment, required this.user});

  @override
  State<ListingCardDetails> createState() => _ListingCardDetailsState();
}

class _ListingCardDetailsState extends State<ListingCardDetails> {
  final priceController = TextEditingController();
  final noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Trip? _selectedTrip;

  void _sendDeliveryRequest(Trip? trip) async {
    if (_isLoading) return;

    if (trip == null) {
      AppUtils.showError(context, 'Please select a trip');
      return;
    }
    if (trip.id == null) {
      AppUtils.showError(context, 'Selected trip is invalid');
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          AppUtils.showError(context, 'Please log in to list a shipment');
          return;
        }
        final DeliveryRequest request = DeliveryRequest(
            tripId: trip.id!,
            senderId: user.uid,
            receiverId: widget.shipment.userId,
            status: DeliveryStatus.active,
            date: DateTime.now().toIso8601String(),
            shipmentId: widget.shipment.id!,
            price: priceController.text);
        await Provider.of<DeliveryRequestProvider>(context, listen: false)
            .addRequest(request);

        if (mounted) {
          Navigator.pop(context);
          priceController.text = "";
          noteController.text = "";
          setState(() {
            _selectedTrip = null;
          });
          AppUtils.showSuccess(context, 'Request sent successfully');
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context);
          AppUtils.showError(context, 'Failed to send request $e');
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // appBar: AppBar(
      // backgroundColor: AppColors.barColor,
      // title: const Text(
      //   "Shipment Details",
      //   style: TextStyle(
      //       color: AppColors.headingText,
      //       fontWeight: FontWeight.bold,
      //       fontSize: 18),
      // ),
      // ),
      body: SingleChildScrollView(
          child: Container(
              color: AppColors.background,
              // padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
              child: Column(
                children: [
                  _displayImage(),
                  _buildUserProfile(),
                  _buildDescription(),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildDetails(),
                ],
              ))),
      floatingActionButton: FloatButton(
        onTap: () {
          _showRequestSheet();
        },
        iconPath: "assets/icon/chat-round-line.svg",
        hintText: "Request",
      ),
    );
  }

  Widget _displayImage() {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            child: Image.asset(
              'assets/images/box.jpg',
              height: AppTheme.imageHeight * 2.5,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Container(
        decoration: const BoxDecoration(
          // borderRadius: BorderRadius.circular(AppTheme.cardPadding),
          border: const Border(
            bottom: BorderSide(color: AppColors.lessImportant, width: 0.2),
            top: BorderSide(color: AppColors.lessImportant, width: 0.2),
          ),
          color: AppColors.cardBackground,
          //  boxShadow: [
          //     BoxShadow(
          //       color: AppColors.blue.withOpacity(0.2), // Shadow color
          //       spreadRadius: 0, // How much the shadow spreads
          //       blurRadius: 2, // Softness of the shadow
          //       offset: Offset(0, 0), // X and Y offset
          //     ),
          // ],
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Package Details",
                style: TextStyle(
                    color: AppColors.headingText,
                    fontWeight: FontWeight.bold,
                    fontSize: 26)),
            const SizedBox(
              height: 10,
            ),
            const Row(
              children: [
                CustomIcon(
                  iconPath: "assets/icon/delivery.svg",
                  color: AppColors.blue,
                  size: 26,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Destination",
                    style: TextStyle(color: AppColors.headingText, fontSize: 20)),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Destination(
                  from: widget.shipment.from,
                  to: widget.shipment.to,
                  fontSize: 18,
                  iconSize: 18,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                CustomIcon(
                  iconPath: "assets/icon/calendar.svg",
                  color: AppColors.blue,
                  size: 24,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Estimated Delivery",
                    style: TextStyle(color: AppColors.headingText, fontSize: 20)),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text(widget.shipment.date,
                    style:
                        const TextStyle(color: AppColors.headingText, fontSize: 18)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                CustomIcon(
                  iconPath: "assets/icon/weight.svg",
                  color: AppColors.blue,
                  size: 24,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Weight",
                    style: TextStyle(color: AppColors.headingText, fontSize: 20)),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text('${widget.shipment.weight} kg',
                    style:
                        const TextStyle(color: AppColors.headingText, fontSize: 18)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                CustomIcon(
                  iconPath: "assets/icon/package.svg",
                  color: AppColors.blue,
                  size: 24,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Quantity & Type",
                    style: TextStyle(color: AppColors.headingText, fontSize: 20)),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text('${widget.shipment.weight} x ${widget.shipment.type}',
                    style:
                        const TextStyle(color: AppColors.headingText, fontSize: 18)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                CustomIcon(
                  iconPath: "assets/icon/package.svg",
                  color: AppColors.blue,
                  size: 24,
                ),
                SizedBox(
                  width: 10,
                ),
                // Text("Starting price",
                //     style: TextStyle(color: AppColors.headingText, fontSize: 20)),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text('${widget.shipment.price} dh',
                    style:
                        const TextStyle(color: AppColors.white, fontSize: 18)),
              ],
            ),
          ],
        ));
  }

  Widget _buildDescription() {
    return Container(
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.circular(AppTheme.cardPadding),
        border: const Border(
          bottom: BorderSide(color: AppColors.lessImportant, width: 0.2),
          top: BorderSide(color: AppColors.lessImportant, width: 0.2),
        ),
        color: AppColors.cardBackground,
        //  boxShadow: [
        //     BoxShadow(
        //       color: AppColors.blue.withOpacity(0.2), // Shadow color
        //       spreadRadius: 1, // How much the shadow spreads
        //       blurRadius: 2, // Softness of the shadow
        //       offset: Offset(0, 0), // X and Y offset
        //     ),
        // ],
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.shipment.packageName,
              style: const TextStyle(
                  fontSize: 26,
                  color: AppColors.headingText,
                  fontWeight: FontWeight.bold)),
          const Text("Package Description",
              style: TextStyle(
                  color: AppColors.headingText,
                  fontWeight: FontWeight.bold,
                  fontSize: 26)),
          Text(widget.shipment.description,
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.headingText,
              )),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
        padding: const EdgeInsets.all(16),
        child: UserProfileCard(
          header: widget.user.displayName ?? "unknow user",
          onPressed: () => print("user profile  Clicked"),
          photoUrl: widget.user.photoUrl ?? AppTheme.defaultProfileImage,
          headerFontSize: 16,
          subHeaderFontSize: 10,
          avatarSize: 22,
        ));
  }

  void _showRequestSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      isScrollControlled: true, // Allows resizing when the keyboard appears
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            maxChildSize: 0.9, // max height
            minChildSize: 0.4,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: _buildRequesBody(),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRequesBody() {
    return Consumer<TripProvider>(builder: (constext, tripProvider, child) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return const Center(child: Text('Please log in to send a request'));
      }
      final activeTrips = tripProvider.trips
          .where((trip) => trip.userId == user.uid && trip.status == "active")
          .toList();

      return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.cardPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.lessImportant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Text(
                  "Select a Trip",
                  style: TextStyle(color: AppColors.headingText, fontSize: 16),
                ),
                const SizedBox(height: 10),
                activeTrips.isEmpty
                    ? const Text(
                        "No active trips match this shipment's destination",
                        style: TextStyle(color: AppColors.error, fontSize: 14),
                      )
                    : DropdownButtonFormField<Trip>(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppColors.lessImportant),
                            )),
                        dropdownColor: AppColors.background,
                        hint: const Text(
                          "Choose a trip",
                          style: TextStyle(color: AppColors.headingText),
                        ),
                        items: activeTrips.map((trip) {
                          return DropdownMenuItem<Trip>(
                            value: trip,
                            child: Text(
                              "${trip.from} to ${trip.to} - ${trip.date}",
                              style: const TextStyle(color: AppColors.headingText),
                            ),
                          );
                        }).toList(),
                        onChanged: (Trip? trip) {
                          _selectedTrip = trip; // Update selected trip
                        },
                        validator: (value) =>
                            value == null ? "Please select a trip" : null,
                      ),
                const SizedBox(height: 20),
                const Text(
                  "Add a note",
                  style: TextStyle(color: AppColors.headingText, fontSize: 16),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: noteController,
                  hintText: "Note",
                  backgroundColor: AppColors.background,
                  maxLines: 2,
                ),
                const Text(
                  "Price",
                  style: TextStyle(color: AppColors.headingText, fontSize: 16),
                ),
                const SizedBox(height: 10),
                NumberField(
                  controller: priceController,
                  hintText: "Start price",
                  backgroundColor: AppColors.background,
                  validator: Validators.notEmpty,
                ),
                const SizedBox(
                  height: 20,
                ),
                LoginButton(
                    hintText: "Send request",
                    isLoading: _isLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _sendDeliveryRequest(_selectedTrip);
                      } else {
                        AppUtils.showError(
                            context, 'Please complete all required fields');
                      }
                    }),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ));
    });
  }
}
