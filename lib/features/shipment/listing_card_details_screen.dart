import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';

class ListingCardDetails extends StatefulWidget {
  final TransportItem shipment;
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
  bool _isTrip = false;
  bool _isLoading = false;
  Shipment? _selectedShipment ;
  Trip? _selectedTrip ;

  @override
  void initState() {
    super.initState();
    if (widget.shipment is Shipment) {
      _selectedShipment = widget.shipment as Shipment?;
    }
    // _isTrip = widget.shipment is Trip;
    if (widget.shipment is Trip) {
      _selectedTrip = widget.shipment as Trip?;
    }

    // print("is trip ${_isTrip}");
  }

  @override
  void dispose() {
    priceController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void _sendDeliveryRequest(Trip? trip) async {
    if (_isLoading) return;

    if (trip == null) {
      AppUtils.showDialog(context, 'Please select a trip', AppColors.error);
      return;
    }
    if (trip.id == null) {
      AppUtils.showDialog(context, 'Selected trip is invalid', AppColors.error);
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          AppUtils.showDialog(
              context, 'Please log in to list a shipment', AppColors.error);
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
          AppUtils.showDialog(
              context, 'Request sent successfully', AppColors.succes);
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context);
          AppUtils.showDialog(
              context, 'Failed to send request $e', AppColors.error);
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildSliverApp() {
    return  SliverAppBar(
            expandedHeight: _selectedShipment == null ? 100 : 300,
            pinned: true,
            backgroundColor: AppColors.background,

            flexibleSpace: _selectedShipment == null ? null : FlexibleSpaceBar(
               background: _displayImage(),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: BackButton(color: Colors.white),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    // Share functionality
                  },
                ),
              ),
            ],
            
          );
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverApp(),
           SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildUserProfile(),
                  _buildDescription(),
                  const SizedBox(height: 20),
                  _buildDetailsSection(),
                  const SizedBox(height: 150), // space for bottom bar
                ],
              ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildPriceAndAction(),
    );
  }
 Widget _buildDetailsSection() {

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Package Details",
            style: TextStyle(
              color: AppColors.headingText,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailItem(
            icon: "assets/icon/delivery.svg",
            title: "Route",
            child: Destination(
              from: widget.shipment.from,
              to: widget.shipment.to,
              fontSize: 16,
              iconSize: 16,
            ),
          ),
          _buildDetailItem(
            icon: "assets/icon/calendar.svg",
            title: "Delivery Date",
            child: Text(
              widget.shipment.date,
              style: const TextStyle(
                color: AppColors.headingText,
                fontSize: 16,
              ),
            ),
          ),
          _buildDetailItem(
            icon: "assets/icon/weight.svg",
            title: _selectedShipment == null ? "Available Weight" : "Weight",
            child: Text(
              '${widget.shipment.weight} kg',
              style: const TextStyle(
                color: AppColors.headingText,
                fontSize: 16,
              ),
            ),
          ),
          // _buildDetailItem(
          //   icon: "assets/icon/package.svg",
          //   title: "Package Type",
          //   child: Text(
          //     '${widget.shipment.weight} kg',
          //     style: const TextStyle(
          //       color: AppColors.headingText,
          //       fontSize: 16,
          //     ),
          //   ),
          // ),
          if (_selectedShipment != null ) _buildDetailItem(
            icon: "assets/icon/package.svg",
            title: "Package type",  
            child: Text(
              '${_selectedShipment?.type } ',
              style: const TextStyle(
                color: AppColors.headingText,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }


   Widget _buildDetailItem({
    required String icon,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: CustomIcon(
              iconPath: icon,
              color: AppColors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.lessImportant,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceAndAction() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Starting from",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lessImportant,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.blue, Colors.purple],
                      ).createShader(bounds),
                      child: Text(
                        widget.shipment.price,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "dh",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: _showRequestSheet,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.blue, Colors.purple],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Text(
                "Make Offer",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
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


  Widget _buildDescription() {

    if (_selectedShipment == null) {
      return Container();
    } 
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      width: double.infinity,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_selectedShipment!.packageName,
              style: const TextStyle(
                  fontSize: 26,
                  color: AppColors.headingText,
                  fontWeight: FontWeight.bold)),
          const Text("Package Description",
              style: TextStyle(
                  color: AppColors.headingText,
                  fontWeight: FontWeight.bold,
                  fontSize: 26)),
          Text(_selectedShipment!.description,
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
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [ 
          UserProfileCard(
            header: widget.user.displayName ?? "unknow user",
            onPressed: () => {context.push("/profile")},
            photoUrl: widget.user.photoUrl ?? AppTheme.defaultProfileImage,
            subHeader: "⭐ 4.5",
            headerFontSize: 16,
            subHeaderFontSize: 10,
            avatarSize: 22,
      ),
      const Spacer(),
       GestureDetector(
            onTap: () => context.push("/profile"),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.blue,
              ),
            ),
       ),

      ]
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
                              style:
                                  const TextStyle(color: AppColors.headingText),
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
                        AppUtils.showDialog(
                            context,
                            'Please complete all required fields',
                            AppColors.error);
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
