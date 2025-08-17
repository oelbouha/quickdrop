import 'package:cached_network_image/cached_network_image.dart';
import 'package:quickdrop_app/core/providers/notification_provider.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';

import 'package:quickdrop_app/features/models/notification_model.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ListingShipmentLoader extends StatefulWidget {
  final String userId;
  final bool viewOnly;
  final String shipmentId;

  const ListingShipmentLoader(
      {super.key,
      required this.userId,
      required this.viewOnly,
      required this.shipmentId});

  @override
  State<ListingShipmentLoader> createState() => _ListingShipmentLoaderState();
}

class _ListingShipmentLoaderState extends State<ListingShipmentLoader> {
  Future<(UserData, TransportItem)> fetchData() async {
    final user = Provider.of<UserProvider>(context, listen: false)
        .getUserById(widget.userId);
    ;
    final transportItem =
        await Provider.of<ShipmentProvider>(context, listen: false)
            .fetchShipmentById(widget.shipmentId);
    if (user == null || transportItem == null) {
      return Future.error("Data not found");
    }
    return (user, transportItem);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(UserData, TransportItem)>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: loadingAnimation(),
          );
        }

        if (snapshot.hasError) {
          return ErrorPage(errorMessage: snapshot.error.toString());
        }

        final (userData, shipmentData) = snapshot.data!;

        return ListingCardDetails(
          user: userData,
          shipment: shipmentData,
          viewOnly: widget.viewOnly,
        );
      },
    );
  }
}

class ListingTripLoader extends StatefulWidget {
  final String userId;
  final bool viewOnly;
  final String shipmentId;

  const ListingTripLoader(
      {super.key,
      required this.userId,
      required this.viewOnly,
      required this.shipmentId});

  @override
  State<ListingTripLoader> createState() => _ListingTripLoaderState();
}

class _ListingTripLoaderState extends State<ListingTripLoader> {
  Future<(UserData, TransportItem)> fetchData() async {
    final user = Provider.of<UserProvider>(context, listen: false)
        .getUserById(widget.userId);
    final transportItem = Provider.of<TripProvider>(context, listen: false)
        .getTrip(widget.shipmentId);
    if (user == null) {
      return Future.error("Data not found");
    }
    return (user, transportItem);
  }

  @override
  Widget build(BuildContext context) {
    print(
        "fetching trip data for ${widget.shipmentId} by user ${widget.userId}");
    return FutureBuilder<(UserData, TransportItem)>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: loadingAnimation(),
          );
        }

        if (snapshot.hasError) {
          return ErrorPage(errorMessage: snapshot.error.toString());
        }

        final (userData, shipmentData) = snapshot.data!;
        
        return ListingCardDetails(
          user: userData,
          shipment: shipmentData,
          viewOnly: widget.viewOnly,
        );
      },
    );
  }
}

class ListingCardDetails extends StatefulWidget {
  final TransportItem shipment;
  final UserData user;
  final bool viewOnly;

  const ListingCardDetails(
      {super.key,
      required this.shipment,
      required this.user,
      this.viewOnly = true});

  @override
  State<ListingCardDetails> createState() => _ListingCardDetailsState();
}

class _ListingCardDetailsState extends State<ListingCardDetails> {
  final priceController = TextEditingController();
  final noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  Shipment? _selectedShipment;
  Trip? _selectedTrip;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();

    if (widget.shipment is Shipment) {
      _selectedShipment = widget.shipment as Shipment?;
      _precacheImages();
    }
    // _isTrip = widget.shipment is Trip;
    if (widget.shipment is Trip) {
      _selectedTrip = widget.shipment as Trip?;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
    // print("is trip ${_isTrip}");
  }

  Future<void> _precacheImages() async {
    try {
      if (_selectedShipment != null) {
        await DefaultCacheManager().downloadFile(
          _selectedShipment!.imageUrl!,
        );
      }
    } catch (e) {
      print('Failed to precache image: $e');
    }
  }

  @override
  void dispose() {
    priceController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Widget _buildSliverApp() {
    return SliverAppBar(
      expandedHeight: _selectedShipment == null ? 100 : 300,
      pinned: true,
      backgroundColor: AppColors.background,
      flexibleSpace: _selectedShipment == null
          ? null
          : FlexibleSpaceBar(
              background: _displayImage(),
            ),
      leading: Container(
        margin: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: BackButton(color: Colors.black),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              // Share functionality
              AppUtils.showDialog(
                  context, "Share feature is comming", AppColors.blue700);
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
                const SizedBox(height: 150),
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
          _buildDetailItem(
            icon: _selectedShipment != null
                ? "assets/icon/package.svg"
                : "assets/icon/car.svg",
            title:
                _selectedShipment != null ? "Package type" : "Transport type",
            child: Text(
              '${_selectedShipment == null ? _selectedTrip!.transportType : _selectedShipment!.type}',
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
              color: AppColors.blue.withValues(alpha: 0.1),
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
    if (widget.viewOnly || _selectedShipment == null ||
        _selectedShipment?.userId == FirebaseAuth.instance.currentUser?.uid) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
                    Text(
                      widget.shipment.price,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue600,
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
          ElevatedButton.icon(
            onPressed: _showRequestSheet,
            icon: const Icon(Icons.send, size: 18),
            label: Text(
              _isMenuOpen ? 'send Request' : 'Send Offer',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _displayImage() {
    if (_selectedShipment != null) {
      return Row(
        children: [
          Expanded(
            child: ClipRRect(
                child: CachedNetworkImage(
              imageUrl:
                  _selectedShipment!.imageUrl ?? AppTheme.defaultProfileImage,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    color: AppColors.blueStart.withValues(alpha: 0.1),
                    // borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.blue700, strokeWidth: 2))),
              errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    color: AppColors.blueStart.withValues(alpha: 0.1),
                    // borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image.asset(
                    "assets/images/box.jpg",
                    fit: BoxFit.cover,
                  )),
            )),
          ),
        ],
      );
    }
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
            color: Colors.black.withValues(alpha: 0.05),
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
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(children: [
          UserProfileWithRating(
            user: widget.user,
            header: widget.user.displayName ?? 'Guest',
            avatarSize: 46,
            headerFontSize: 16,
            onPressed: () =>
                {context.push('/profile/statistics?userId=${widget.user.uid}')},
          ),
          const Spacer(),
          GestureDetector(
            onTap: () =>
                context.push('/profile/statistics?userId=${widget.user.uid}'),
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
        ]));
  }

  void _showRequestSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      isScrollControlled: true, // Allows resizing when the keyboard appears
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      barrierColor: Colors.black.withValues(alpha: 0.5),
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
// Replace the _sendDeliveryRequest method with this version:

  void _sendDeliveryRequest(Trip? trip, [StateSetter? setModalState]) async {
    if (_isLoading) return;

    if (!_formKey.currentState!.validate()) {
      AppUtils.showDialog(
          context, 'Please complete all required fields', AppColors.error);
      return;
    }
    if (trip == null) {
      AppUtils.showDialog(context, 'Please select a trip', AppColors.error);
      return;
    }
    if (trip.id == null) {
      AppUtils.showDialog(context, 'Selected trip is invalid', AppColors.error);
      return;
    }

    // Helper function to update loading state
    void updateLoadingState(bool isLoading) {
      if (setModalState != null) {
        setModalState(() {
          _isLoading = isLoading;
        });
      }
      setState(() {
        _isLoading = isLoading;
      });
    }

    try {
      updateLoadingState(true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        updateLoadingState(false);
        AppUtils.showDialog(
            context, 'Please log in to list a shipment', AppColors.error);
        return;
      }

      await Provider.of<DeliveryRequestProvider>(context, listen: false)
          .sendRequest(trip, widget.shipment as Shipment);

      // Stop loading
      updateLoadingState(false);

      if (mounted) {
        // Clear form and reset state
        priceController.clear();
        noteController.clear();
        setState(() {
          _selectedTrip = null;
        });

        // Show success message
        AppUtils.showDialog(
            context, 'Request sent successfully', AppColors.succes);
        Navigator.pop(context);

        // Close the bottom sheet after a short delay
        // Future.delayed(const Duration(milliseconds: 1000), () {
        //   if (mounted) {
        //   }
        // });
      }
    } catch (e) {
      updateLoadingState(false);
      if (mounted) {
        AppUtils.showDialog(context, e.toString(), AppColors.error);
      }
    } finally {
      // Ensure loading state is reset even if an error occurs
      updateLoadingState(false);
      Navigator.pop(context);
    }
  }

// Also update the _buildRequesBody method to use StatefulBuilder:

  Widget _buildRequesBody() {
    return Consumer<TripProvider>(builder: (context, tripProvider, child) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return const Center(child: Text('Please log in to send a request'));
      }

      final activeTrips = tripProvider.trips
          .where((trip) => trip.userId == user.uid && trip.status == "active")
          .toList();

      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
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
                    style:
                        TextStyle(color: AppColors.headingText, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  activeTrips.isEmpty
                      ? const Text(
                          "No active trips match this shipment's destination",
                          style:
                              TextStyle(color: AppColors.error, fontSize: 14),
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
                                style: const TextStyle(
                                    color: AppColors.headingText),
                              ),
                            );
                          }).toList(),
                          onChanged: (Trip? trip) {
                            setState(() {
                              _selectedTrip = trip;
                            });
                          },
                          validator: (value) =>
                              value == null ? "Please select a trip" : null,
                        ),
                  const SizedBox(height: 20),
                  TextFieldWithHeader(
                    controller: noteController,
                    hintText: "Add a note",
                    headerText: "Note",
                    keyboardType: TextInputType.text,
                    isRequired: false,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  TextFieldWithHeader(
                    controller: priceController,
                    hintText: "0.00",
                    headerText: "Price (dh)",
                    validator: Validators.isNumber,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Button(
                      hintText: "Send request",
                      isLoading: _isLoading,
                      onPressed: () {
                        _sendDeliveryRequest(_selectedTrip, setModalState);
                      }),
                  const SizedBox(height: 10),
                ],
              ),
            ));
      });
    });
  }
}
