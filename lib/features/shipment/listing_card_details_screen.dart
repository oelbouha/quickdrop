import 'package:cached_network_image/cached_network_image.dart';
import 'package:quickdrop_app/core/providers/notification_provider.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/route_indicator.dart';
import 'package:collection/collection.dart';

import 'package:share_plus/share_plus.dart';
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
  bool _isTrip = false;

  Shipment? _targetShipment;
  Trip? _targetTrip;

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
      _isTrip = true;
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
    final t = AppLocalizations.of(context)!;
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
              Share.share(t.share_message, subject: t.share_subject);
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
                // const SizedBox(height: 150),
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
    final t = AppLocalizations.of(context)!;
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
          Text(
            t.package_details,
            style: const TextStyle(
              color: AppColors.headingText,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailItem(
            icon: "assets/icon/delivery.svg",
            title: t.route,
            child: _isTrip &&
                    _selectedTrip?.middleStops != null &&
                    _selectedTrip!.middleStops!.isNotEmpty
                ? RouteWithStops(
                    from: widget.shipment.from,
                    to: widget.shipment.to,
                    middleStops: _selectedTrip!.middleStops,
                    fontSize: 16,
                  )
                : RouteIndicator(
                    from: widget.shipment.from,
                    to: widget.shipment.to,
                    fontSize: 16,
                    iconSize: 16,
                  ),
          ),
          _buildDetailItem(
            icon: "assets/icon/calendar.svg",
            title: t.pickup_date,
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
            title:
                _selectedShipment == null ? t.available_weight : t.weight_label,
            child: Text(
              '${widget.shipment.weight} ${t.kg}',
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
            title: _selectedShipment != null
                ? t.package_type_label
                : t.transport_type,
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
    final t = AppLocalizations.of(context)!;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (widget.viewOnly ||
        _selectedShipment?.userId == userId ||
        _selectedTrip?.userId == userId) {
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
                Text(
                  t.starting_from,
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
                      t.dirham,
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
              _isMenuOpen ? t.send_request : t.send_offer,
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
    final t = AppLocalizations.of(context)!;
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
          Text(t.package_description_label,
              style: const TextStyle(
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

  void _sendDeliveryRequest(Trip? trip, Shipment? shipment,
      [StateSetter? setModalState]) async {
    final t = AppLocalizations.of(context)!;

    final canDrive = Provider.of<UserProvider>(context, listen: false)
        .canDriverMakeActions();
    if (!canDrive) {
      context.pop();
      AppUtils.showDialog(
          context, t.driver_cannot_create_trip_message, AppColors.error);
      return;
    }

    if (_isLoading) return;

    if (!_formKey.currentState!.validate()) {
      AppUtils.showDialog(
          context, t.please_complete_all_fields, AppColors.error);
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
        AppUtils.showDialog(context, t.login_required, AppColors.error);
        return;
      }

      if (trip != null) {
        await Provider.of<DeliveryRequestProvider>(context, listen: false)
            .sendRequest(trip, widget.shipment as Shipment, trip.userId,
                widget.shipment.userId);
      } else {
        await Provider.of<DeliveryRequestProvider>(context, listen: false)
            .sendRequest(_selectedTrip!, shipment!, shipment.userId,
                _selectedTrip!.userId);
      }

      // Stop loading
      updateLoadingState(false);

      if (mounted) {
        priceController.clear();
        noteController.clear();

        AppUtils.showDialog(context, t.request_sent_success, AppColors.succes);
      }
    } catch (e) {
      updateLoadingState(false);
      final errorMessage = e.toString();
      if (errorMessage.contains("already_exists")) {
        AppUtils.showDialog(context, t.request_already_sent, AppColors.error);
      } else if (errorMessage.contains("owner_is_the_same")) {
        AppUtils.showDialog(
            context, t.trip_owner_cannot_request, AppColors.error);
      } else {
        AppUtils.showDialog(
            context, t.driver_mode_request_failed, AppColors.error);
      }
    } finally {
      updateLoadingState(false);
      Navigator.pop(context);
    }
  }

  List<Shipment> _getMatchedShipments() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return [];
    }

    final trip = widget.shipment as Trip;
    final from = trip.from;
    final to = trip.to;
    final middleStops = trip.middleStops ?? [];

    final shipmentProvider =
        Provider.of<ShipmentProvider>(context, listen: false);
    shipmentProvider.fetchShipmentsByUserId(userId);

    final shipments = shipmentProvider.shipments
        .where((shipment) =>
            shipment.userId == userId &&
                shipment.status == "active" &&
                shipment.from == from &&
                shipment.to == to ||
            middleStops.contains(shipment.from) ||
            middleStops.contains(shipment.to))
        .toList();

    return shipments;
  }

  List<Trip> _getMatchedTrips() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return [];
    }

    final shipment = widget.shipment as Shipment;
    final from = shipment.from;
    final to = shipment.to;

    final tripProvider = Provider.of<TripProvider>(context, listen: false);

    final trips = tripProvider.trips
        .where((trip) =>
            trip.userId == userId &&
            trip.status == "active" &&
            (trip.from == from && trip.to == to ||
                (trip.middleStops != null &&
                    trip.middleStops!.contains(from)) ||
                (trip.middleStops != null && trip.middleStops!.contains(to))))
        .toList();

    return trips;
  }

  Widget _buildRequesBody() {
    final t = AppLocalizations.of(context)!;
    return Consumer2<TripProvider, ShipmentProvider>(
        builder: (context, tripProvider, shipmentProvider, child) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return Center(child: Text(t.login_required));
      }

      List<Trip> activeTrips = [];
      if (_isTrip == false) {
        activeTrips = _getMatchedTrips();
      }

      List<Shipment> activeShipments = [];
      if (_isTrip == true) {
        activeShipments = _getMatchedShipments();
      }

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
                  Text(
                    _isTrip ? t.choose_a_shipment : t.choose_a_trip,
                    style: const TextStyle(
                        color: AppColors.headingText, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  activeTrips.isEmpty && activeShipments.isEmpty
                      ? Text(
                          _isTrip
                              ? t.no_active_trips_available
                              : t.no_active_shipments_available,
                          style: const TextStyle(
                              color: AppColors.error, fontSize: 14),
                        )
                      : _isTrip == false
                          ? TripDropdownField(
                              trips: activeTrips,
                              selectedTripId: _selectedTrip?.id,
                              hintText: t.choose_a_trip,
                              onChanged: (trip) {
                                setModalState(() {
                                  _targetTrip = trip;
                                });
                              },
                              validator: (value) =>
                                  value == null ? t.please_select_trip : null,
                            )
                          : ShipmentDropdownField(
                              shipments: activeShipments,
                              selectedShipmentId: _selectedShipment?.id,
                              hintText: t.choose_a_shipment,
                              onChanged: (shipment) {
                                setModalState(() {
                                  _targetShipment = shipment;
                                });
                              },
                              validator: (value) => value == null
                                  ? t.please_select_shipment
                                  : null,
                            ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: noteController,
                    hintText: t.add_a_note,
                    label: t.note,
                    keyboardType: TextInputType.text,
                    isRequired: false,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: priceController,
                    hintText: t.delivery_price_hint,
                    label: t.delivery_price_label,
                    validator: Validators.isNumber(context),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Button(
                      hintText: t.send_request,
                      isLoading: _isLoading,
                      onPressed: () {
                        _sendDeliveryRequest(
                            _targetTrip, _targetShipment, setModalState);
                      }),
                  const SizedBox(height: 10),
                ],
              ),
            ));
      });
    });
  }
}

class ShipmentDropdownField extends StatelessWidget {
  final List<Shipment> shipments;
  final String? selectedShipmentId;
  final String hintText;
  final ValueChanged<Shipment?> onChanged;
  final String? Function(Shipment?)? validator;

  const ShipmentDropdownField({
    super.key,
    required this.shipments,
    required this.selectedShipmentId,
    required this.hintText,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return DropdownButtonFormField<String>(
      value: selectedShipmentId,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.lessImportant),
        ),
      ),
      dropdownColor: AppColors.background,
      hint: Text(
        hintText,
        style: const TextStyle(color: AppColors.headingText),
      ),
      items: shipments.map((shipment) {
        return DropdownMenuItem<String>(
          value: shipment.id,
          child: Text(
            "${shipment.from} ${t.to_hint} ${shipment.to}",
            style: const TextStyle(color: AppColors.headingText),
          ),
        );
      }).toList(),
      onChanged: (id) {
        final selected = shipments.firstWhere((s) => s.id == id);
        onChanged(selected);
      },
      validator: (id) {
        final shipment = shipments.firstWhereOrNull((s) => s.id == id);
        return validator?.call(shipment);
      },
    );
  }
}

class TripDropdownField extends StatelessWidget {
  final List<Trip> trips;
  final String? selectedTripId;
  final String hintText;
  final ValueChanged<Trip?> onChanged;
  final String? Function(Trip?)? validator;

  const TripDropdownField({
    super.key,
    required this.trips,
    required this.selectedTripId,
    required this.hintText,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return DropdownButtonFormField<String>(
      value: selectedTripId,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.lessImportant),
        ),
      ),
      dropdownColor: AppColors.background,
      hint: Text(
        hintText,
        style: const TextStyle(color: AppColors.headingText),
      ),
      items: trips.map((trip) {
        return DropdownMenuItem<String>(
          value: trip.id,
          child: Text(
            "${trip.from} ${t.to_hint} ${trip.to}",
            style: const TextStyle(color: AppColors.headingText),
          ),
        );
      }).toList(),
      onChanged: (id) {
        final selected = trips.firstWhere((t) => t.id == id);
        onChanged(selected);
      },
      validator: (id) {
        final trip = trips.firstWhereOrNull((t) => t.id == id);
        return validator?.call(trip);
      },
    );
  }
}

class RouteWithStops extends StatelessWidget {
  final String from;
  final String to;
  final List<String>? middleStops;
  final double fontSize;

  const RouteWithStops({
    super.key,
    required this.from,
    required this.to,
    this.middleStops,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Departure
        _buildRoutePoint(
          city: from,
          label: 'Departure',
          isStart: true,
          isEnd: false,
        ),

        // Middle stops
        if (middleStops != null && middleStops!.isNotEmpty)
          ...middleStops!.asMap().entries.map((entry) {
            return _buildRoutePoint(
              city: entry.value,
              label: '${t.stop ?? 'Stop'} ${entry.key + 1}',
              isStart: false,
              isEnd: false,
            );
          }).toList(),

        // Arrival
        _buildRoutePoint(
          city: to,
          label: 'Arrival',
          isStart: false,
          isEnd: true,
        ),
      ],
    );
  }

  Widget _buildRoutePoint({
    required String city,
    required String label,
    required bool isStart,
    required bool isEnd,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            // Dot
            Container(
              width: isStart || isEnd ? 12 : 8,
              height: isStart || isEnd ? 12 : 8,
              decoration: BoxDecoration(
                color: isStart
                    ? AppColors.blue600
                    : isEnd
                        ? Colors.green
                        : AppColors.lessImportant,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isStart
                      ? AppColors.blue600
                      : isEnd
                          ? Colors.green
                          : AppColors.lessImportant,
                  width: isStart || isEnd ? 3 : 2,
                ),
              ),
            ),
            // Line connector (don't show after last point)
            if (!isEnd)
              Container(
                width: 2,
                height: 32,
                color: AppColors.lessImportant.withValues(alpha: 0.3),
              ),
          ],
        ),
        const SizedBox(width: 12),
        // Text content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isEnd ? 0 : 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight:
                        isStart || isEnd ? FontWeight.bold : FontWeight.w600,
                    color: AppColors.headingText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize - 3,
                    color: AppColors.lessImportant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
