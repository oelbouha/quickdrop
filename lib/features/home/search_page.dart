import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:flutter/services.dart';





class SearchResultsScreen extends StatefulWidget {
  final SearchFilters filters;

  const SearchResultsScreen({
    super.key,
    required this.filters,
  });

  @override
  SearchResultsScreenState createState() => SearchResultsScreenState();
}



class SearchResultsScreenState extends State<SearchResultsScreen>
    with TickerProviderStateMixin,  AutomaticKeepAliveClientMixin {


  bool _isLoading = true;
  List<Shipment> activeShipments = [];
  List<Trip> activeTrips = [];


  late AnimationController _animationController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _animationController.forward();
    _performSearch();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Shipment> _filterShipments(List<Shipment> shipments) {
    return shipments.where((shipment) {
      // Filter by 'from' location
      if (widget.filters.from != null && widget.filters.from!.isNotEmpty) {
        if (!shipment.from
            .toLowerCase()
            .contains(widget.filters.from!.toLowerCase())) {
          return false;
        }
      }

      // Filter by 'to' location
      if (widget.filters.to != null && widget.filters.to!.isNotEmpty) {
        if (!shipment.to
            .toLowerCase()
            .contains(widget.filters.to!.toLowerCase())) {
          return false;
        }
      }

      // Filter by price
      if (widget.filters.price != null && widget.filters.price!.isNotEmpty) {
        final filterPrice = double.tryParse(widget.filters.price!);
        final shipmentPrice = double.tryParse(shipment.price);
        if (filterPrice != null &&
            shipmentPrice != null &&
            shipmentPrice > filterPrice) {
          return false;
        }
      }

      // Filter by weight
      if (widget.filters.weight != null && widget.filters.weight!.isNotEmpty) {
        final filterWeight = double.tryParse(widget.filters.weight!);
        final shipmentWeight = double.tryParse(shipment.weight);
        if (filterWeight != null &&
            shipmentWeight != null &&
            shipmentWeight > filterWeight) {
          return false;
        }
      }

      // Filter by date
      if (widget.filters.date != null && widget.filters.date!.isNotEmpty) {
        final filterDate = DateTime.tryParse(widget.filters.date!);
        final shipmentDate = DateTime.tryParse(shipment.date);
        if (filterDate != null &&
            shipmentDate != null &&
            shipmentDate.isBefore(filterDate)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  List<Trip> _filterTrips(List<Trip> trips) {
    return trips.where((trip) {
      // Filter by 'from' location
      if (widget.filters.from != null && widget.filters.from!.isNotEmpty) {
        if (!trip.from
            .toLowerCase()
            .contains(widget.filters.from!.toLowerCase())) {
          return false;
        }
      }

      // Filter by 'to' location
      if (widget.filters.to != null && widget.filters.to!.isNotEmpty) {
        final destination = trip.to.toLowerCase();
        final searchDestination = widget.filters.to!.toLowerCase();
        final middleStops =
            trip.middleStops?.map((stop) => stop.toLowerCase()).toList() ?? [];
        final matchesDestination = destination.contains(searchDestination) ||
            middleStops.any((stop) => stop.contains(searchDestination));

        if (!matchesDestination) {
          return false;
        }
      }

      // Filter by price
      if (widget.filters.price != null && widget.filters.price!.isNotEmpty) {
        final filterPrice = double.tryParse(widget.filters.price!);
        final tripPrice = double.tryParse(trip.price);
        if (filterPrice != null &&
            tripPrice != null &&
            tripPrice > filterPrice) {
          return false;
        }
      }

      // Filter by weight
      if (widget.filters.weight != null && widget.filters.weight!.isNotEmpty) {
        final filterWeight = double.tryParse(widget.filters.weight!);
        final tripWeight = double.tryParse(trip.weight);
        if (filterWeight != null &&
            tripWeight != null &&
            tripWeight < filterWeight) {
          return false;
        }
      }

      // Filter by date
      if (widget.filters.date != null && widget.filters.date!.isNotEmpty) {
        final filterDate = DateTime.tryParse(widget.filters.date!);
        final tripDate = DateTime.tryParse(trip.date);
        if (filterDate != null &&
            tripDate != null &&
            tripDate.isBefore(filterDate)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _performSearch() async {
    setState(() {
      _isLoading = true;
    });
    // Fetch shipments and trips from providers

    final shipmentProvider =
        Provider.of<ShipmentProvider>(context, listen: false);
    final tripProvider = Provider.of<TripProvider>(context, listen: false);

    await shipmentProvider.fetchShipments();
    await tripProvider.fetchTrips();

    final userIds =
        shipmentProvider.shipments.map((r) => r.userId).toSet().toList();
    final tripUserIds =
        tripProvider.trips.map((r) => r.userId).toSet().toList();

    await Provider.of<UserProvider>(context, listen: false)
        .fetchUsersData(userIds);
    await Provider.of<UserProvider>(context, listen: false)
        .fetchUsersData(tripUserIds);

    List<Shipment> filteredShipments = [];
    List<Trip> filteredTrips = [];

    // Apply filters based on type
    if (widget.filters.type == null || widget.filters.type == 'Shipment') {
      filteredShipments = _filterShipments(shipmentProvider.activeShipments);
    }

    if (widget.filters.type == null || widget.filters.type == 'Trip') {
      filteredTrips = _filterTrips(tripProvider.activeTrips);
    }

    setState(() {
      activeShipments = filteredShipments;
      activeTrips = filteredTrips;
      _isLoading = false;
    });
  }

  Widget _buildFilterSummary() {
    final t = AppLocalizations.of(context)!;
    List<String> appliedFilters = [];

    if (widget.filters.from != null && widget.filters.from!.isNotEmpty) {
      appliedFilters.add('${t.from_hint}: ${widget.filters.from}');
    }
    if (widget.filters.to != null && widget.filters.to!.isNotEmpty) {
      appliedFilters.add('${t.to_hint}: ${widget.filters.to}');
    }
    if (widget.filters.weight != null && widget.filters.weight!.isNotEmpty) {
      appliedFilters.add('${t.max_weight}: ${widget.filters.weight} ${t.kg}');
    }
    if (widget.filters.price != null && widget.filters.price!.isNotEmpty) {
      appliedFilters.add('${t.max_price}: ${widget.filters.price} ${t.dirham}');
    }
    if (widget.filters.type != null && widget.filters.type!.isNotEmpty) {
      appliedFilters.add('${t.type}: ${widget.filters.type == 'Shipment' ? t.shipments : t.trips}');
    }
    if (widget.filters.date != null && widget.filters.date!.isNotEmpty) {
      appliedFilters.add('${t.date}: ${widget.filters.date}');
    }

    if (appliedFilters.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blue700.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blue700.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            '${AppLocalizations.of(context)!.applied_filtter}:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.blue700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            appliedFilters.join(' • '),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.blue700.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentListings(List<Shipment> activeShipments) {
    return Consumer2<ShipmentProvider, UserProvider>(
      builder: (context, shipmentProvider, userProvider, child) {
        return activeShipments.isEmpty
            ? buildEmptyState(
                Icons.add_box,
                AppLocalizations.of(context)!.no_result,
                AppLocalizations.of(context)!.no_result_message,
              )
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.filters.type == null ||
                        (widget.filters.type != 'Trip' &&
                            activeTrips.isNotEmpty))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          '${AppLocalizations.of(context)!.shipments} (${activeShipments.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: activeShipments.length,
                      itemBuilder: (context, index) {
                        final shipment = activeShipments[index];
                        final userData =
                            userProvider.getUserById(shipment.userId);
                        if (userData == null) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            ShipmentCard(
                              shipment: shipment,
                              userData: userData,
                              onPressed: () {
                                context.push(
                                    '/shipment-details?shipmentId=${shipment.id}&userId=${shipment.userId}&viewOnly=false');
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget _buildTripListings(List<Trip> activeTrips) {
    return Consumer2<TripProvider, UserProvider>(
      builder: (context, tripProvider, userProvider, child) {
        return activeTrips.isEmpty
            ? buildEmptyState(
                Icons.add_box,
                AppLocalizations.of(context)!.no_result,
                AppLocalizations.of(context)!.no_result_message,
              )
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.filters.type == null ||
                        (widget.filters.type != 'Shipment' &&
                            activeShipments.isNotEmpty))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          '${AppLocalizations.of(context)!.trips} (${activeTrips.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: activeTrips.length,
                      itemBuilder: (context, index) {
                        final trip = activeTrips[index];
                        final userData = userProvider.getUserById(trip.userId);
                        if (userData == null) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            TripCard(
                              shipment: trip,
                              userData: userData,
                              onPressed: () {
                                context.push(
                                    '/trip-details?tripId=${trip.id}&userId=${trip.userId}&viewOnly=false');
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget _buildResultsContent() {
    final screenHeight = MediaQuery.of(context).size.height;
    if (_isLoading) {
      return Container(
        height: screenHeight * 0.7,
        alignment: Alignment.center,
        child: loadingAnimation(),
      );
    }

    bool hasResults = activeShipments.isNotEmpty || activeTrips.isNotEmpty;

    if (!hasResults) {
      return Container(
          height: screenHeight * 0.7,
          alignment: Alignment.center,
          child: buildEmptyState(
            Icons.add_box,
            AppLocalizations.of(context)!.no_result,
            AppLocalizations.of(context)!.no_result_message,
          ));
    }

    return Column(
      children: [
        _buildFilterSummary(),
        // const SizedBox(height: 20),
        if (widget.filters.type == null || widget.filters.type == 'Shipment')
          _buildShipmentListings(activeShipments),
        if (widget.filters.type == null || widget.filters.type == 'Trip')
          _buildTripListings(activeTrips),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildSliverApp() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title:  Text(
        AppLocalizations.of(context)!.search,
        style:  const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverApp(),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _buildResultsContent(),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        backgroundColor: AppColors.blue700,
        foregroundColor: Colors.white,
        label:  Text(AppLocalizations.of(context)!.new_search),
        icon: const Icon(Icons.search),
      ),
    );
  }


}



class SearchFilters {
  final String? from;
  final String? price;
  final String? weight;
  final String? to;
  final String? date;
  final String? type; // 'Shipment' or 'Trip'

  const SearchFilters({
    this.from,
    this.price,
    this.weight,
    this.to,
    this.date,
    this.type,
  });

  // Copy with method for easier filter updates
  SearchFilters copyWith({
    String? from,
    String? price,
    String? weight,
    String? to,
    String? date,
    String? type,
  }) {
    return SearchFilters(
      from: from ?? this.from,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      to: to ?? this.to,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }

  // Check if filters are empty
  bool get isEmpty {
    return (from == null || from!.isEmpty) &&
        (price == null || price!.isEmpty) &&
        (weight == null || weight!.isEmpty) &&
        (to == null || to!.isEmpty) &&
        (date == null || date!.isEmpty) &&
        (type == null || type!.isEmpty);
  }

  // Convert to map for easy debugging or serialization
  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'price': price,
      'weight': weight,
      'to': to,
      'type': type,
      'date': date
    };
  }

  @override
  String toString() {
    return 'SearchFilters(from: $from, to: $to, price: $price, weight: $weight, type: $type, date: $date)';
  }
}
