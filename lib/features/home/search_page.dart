import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  bool _isSearching = false;
  bool _hasSearched = false;
  List<Shipment> activeShipments = [];
  List<Trip> activeTrips = [];

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final weightController = TextEditingController();
  final priceController = TextEditingController();
  final typeController = TextEditingController();
  late SearchFilters filters;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    filters = const SearchFilters();
    typeController.text = "Shipment";
     _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    weightController.dispose();
    priceController.dispose();
    typeController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<Shipment> _filterShipments(List<Shipment> shipments) {
    return shipments.where((shipment) {
      // Filter by 'from' location
      if (filters.from != null && filters.from!.isNotEmpty) {
        if (!shipment.from.toLowerCase().contains(filters.from!.toLowerCase())) {
          return false;
        }
      }

      // Filter by 'to' location
      if (filters.to != null && filters.to!.isNotEmpty) {
        if (!shipment.to.toLowerCase().contains(filters.to!.toLowerCase())) {
          return false;
        }
      }

      // Filter by price
      if (filters.price != null && filters.price!.isNotEmpty) {
        final filterPrice = double.tryParse(filters.price!);
        final shipmentPrice = double.tryParse(shipment.price);
        if (filterPrice != null && shipmentPrice != null && shipmentPrice > filterPrice) {
          return false;
        }
      }

      // Filter by weight
      if (filters.weight != null && filters.weight!.isNotEmpty) {
        final filterWeight = double.tryParse(filters.weight!);
        final shipmentWeight = double.tryParse(shipment.weight);
        if (filterWeight != null && shipmentWeight != null && shipmentWeight > filterWeight) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  List<Trip> _filterTrips(List<Trip> trips) {
    return trips.where((trip) {
      // Filter by 'from' location
      if (filters.from != null && filters.from!.isNotEmpty) {
        if (!trip.from.toLowerCase().contains(filters.from!.toLowerCase())) {
          return false;
        }
      }

      // Filter by 'to' location
      if (filters.to != null && filters.to!.isNotEmpty) {
        if (!trip.to.toLowerCase().contains(filters.to!.toLowerCase())) {
          return false;
        }
      }

      // Filter by price
      if (filters.price != null && filters.price!.isNotEmpty) {
        final filterPrice = double.tryParse(filters.price!);
        final tripPrice = double.tryParse(trip.price);
        if (filterPrice != null && tripPrice != null && tripPrice > filterPrice) {
          return false;
        }
      }

      // Filter by weight
      if (filters.weight != null && filters.weight!.isNotEmpty) {
        final filterWeight = double.tryParse(filters.weight!);
        final tripWeight = double.tryParse(trip.weight);
        if (filterWeight != null && tripWeight != null && tripWeight < filterWeight) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Compact filter section designed for AppBar
  Widget _buildCompactFilterSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: 48,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: fromController,
                    decoration: const InputDecoration(
                      hintText: "From",
                      hintStyle: TextStyle(fontSize: 14),
                      prefixIcon: Icon(Icons.location_on, size: 18),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: toController,
                    decoration: const InputDecoration(
                      hintText: "To",
                      hintStyle: TextStyle(fontSize: 14),
                      prefixIcon: Icon(Icons.location_on, size: 18),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Weight, Price, and Type in a row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Weight (kg)",
                      hintStyle: TextStyle(fontSize: 14),
                      prefixIcon: Icon(Icons.scale, size: 18),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Price (dh)",
                      hintStyle: TextStyle(fontSize: 14),
                      prefixIcon: Icon(Icons.attach_money, size: 18),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Compact Type Selector
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: typeController.text.isEmpty ? "Shipment" : typeController.text,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          typeController.text = newValue;
                        });
                      }
                    },
                    items: ["Shipment", "Trip"].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(value, style: const TextStyle(fontSize: 14)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _clearSearchFilter,
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Clear', style: TextStyle(fontSize: 14)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _isSearching ? null : _applySearchFilter,
                  icon: _isSearching 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.search, size: 16),
                  label: Text(_isSearching ? 'Searching...' : 'Search', 
                             style: const TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    if (!_hasSearched) {
      return _buildWelcomeState();
    }

    if (_isSearching) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      children: [
        _buildFilterSummary(),
        //  const SizedBox(height: 20),
        if (filters.type == null || filters.type == 'Shipment')
          _buildShipmentListings(activeShipments),
        if (filters.type == null || filters.type == 'Trip')
          _buildTripListings(activeTrips),
      ],
    );
  }

  Widget _buildWelcomeState() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.blue700.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.search,
              size: 60,
              color: AppColors.blue700,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Ready to Search',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Fill in the filters above and tap search to find shipments and trips',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  void _clearSearchFilter() {
    setState(() {
      fromController.clear();
      toController.clear();
      weightController.clear();
      priceController.clear();
      typeController.text = "Shipment";
      _hasSearched = false;
      activeShipments.clear();
      activeTrips.clear();
      filters = const SearchFilters();
    });
  }

  void _applySearchFilter() async {
    if (fromController.text.isEmpty &&
        toController.text.isEmpty &&
        weightController.text.isEmpty &&
        priceController.text.isEmpty &&
        typeController.text.isEmpty) {
      AppUtils.showDialog(
          context, 'Please fill at least one field', AppColors.error);
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Create filters from form input
    SearchFilters newFilters = SearchFilters(
      from: fromController.text.isEmpty ? null : fromController.text,
      to: toController.text.isEmpty ? null : toController.text,
      price: priceController.text.isEmpty ? null : priceController.text,
      weight: weightController.text.isEmpty ? null : weightController.text,
      type: typeController.text.isEmpty ? "Shipment" : typeController.text,
    );

    final shipmentProvider = Provider.of<ShipmentProvider>(context, listen: false);
    final tripProvider = Provider.of<TripProvider>(context, listen: false);

    // Clear previous results
    List<Shipment> filteredShipments = [];
    List<Trip> filteredTrips = [];

    // Apply filters based on type
    if (newFilters.type == null || newFilters.type == 'Shipment') {
      filteredShipments = _filterShipments(shipmentProvider.activeShipments);
    }
    
    if (newFilters.type == null || newFilters.type == 'Trip') {
      filteredTrips = _filterTrips(tripProvider.activeTrips);
    }

    setState(() {
      filters = newFilters;
      activeShipments = filteredShipments;
      activeTrips = filteredTrips;
      _isSearching = false;
      _hasSearched = true;
    });
  }

  Widget _buildFilterSummary() {
    List<String> appliedFilters = [];
    
    if (filters.from != null && filters.from!.isNotEmpty) {
      appliedFilters.add('From: ${filters.from}');
    }
    if (filters.to != null && filters.to!.isNotEmpty) {
      appliedFilters.add('To: ${filters.to}');
    }
    if (filters.weight != null && filters.weight!.isNotEmpty) {
      appliedFilters.add('Max Weight: ${filters.weight} kg');
    }
    if (filters.price != null && filters.price!.isNotEmpty) {
      appliedFilters.add('Max Price: ${filters.price} dh');
    }
    if (filters.type != null && filters.type!.isNotEmpty) {
      appliedFilters.add('Type: ${filters.type}');
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
          const Text(
            'Applied Filters:',
            style: TextStyle(
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

  Widget _buildEmptyState(String message, String iconPath) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.blue700.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: CustomIcon(
              iconPath: iconPath,
              size: 40,
              color: AppColors.blue700.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
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
            ? _buildEmptyState("No Shipments Found", 'assets/icons/package.svg')
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (filters.type == null || (filters.type != 'Trip' && activeTrips.isNotEmpty))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Shipments (${activeShipments.length})',
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
                        final userData = userProvider.getUserById(shipment.userId);
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
            ? _buildEmptyState("No Trips Found", 'assets/icons/car.svg')
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (filters.type == null || (filters.type != 'Shipment' && activeShipments.isNotEmpty))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Trips (${activeTrips.length})',
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
                            ShipmentCard(
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

  Widget _buildSliverApp() {
    return SliverAppBar(
      expandedHeight: 240, 
      floating: true,
      pinned: true,
      stretch: true,
      title: const Text(
        'Search',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.blue700.withValues(alpha: 0.1),
          child: SafeArea(
            child: Container(
              // margin: const EdgeInsets.only(
              //   top: 26,
              // ),
              child: _buildCompactFilterSection(),
          )),
        ),
      ),     
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverApp(),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildResultsSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchFilters {
  final String? from;
  final String? price;
  final String? weight;
  final String? to;
  final String? type; // 'Shipment' or 'Trip'

  const SearchFilters({
    this.from,
    this.price,
    this.weight,
    this.to,
    this.type,
  });
}