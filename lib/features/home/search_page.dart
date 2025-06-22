
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

class SearchPage extends StatefulWidget {
  final SearchFilters filters;
  const SearchPage({
    super.key, 
    required this.filters
  });

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  bool _isSearching = true;
  List<Shipment> activeShipments = [];
  List<Trip> activeTrips = [];

  @override
  void initState() {
    super.initState();

    final shipmentProvider =
        Provider.of<ShipmentProvider>(context, listen: false);
    final tripProvider = Provider.of<TripProvider>(context, listen: false);

    // Apply filters based on type
    if (widget.filters.type == null || widget.filters.type == 'Shipment') {
      activeShipments = _filterShipments(shipmentProvider.activeShipments);
    }
    
    if (widget.filters.type == null || widget.filters.type == 'Trip') {
      activeTrips = _filterTrips(tripProvider.activeTrips);
    }

    setState(() {
      _isSearching = false;
    });
  }

  List<Shipment> _filterShipments(List<Shipment> shipments) {
    return shipments.where((shipment) {
      // Filter by 'from' location
      if (widget.filters.from != null && widget.filters.from!.isNotEmpty) {
        if (!shipment.from.toLowerCase().contains(widget.filters.from!.toLowerCase())) {
          return false;
        }
      }

      // Filter by 'to' location
      if (widget.filters.to != null && widget.filters.to!.isNotEmpty) {
        if (!shipment.to.toLowerCase().contains(widget.filters.to!.toLowerCase())) {
          return false;
        }
      }

      // Filter by price (assuming you want shipments with price <= filter price)
      if (widget.filters.price != null && widget.filters.price!.isNotEmpty) {
        final filterPrice = double.tryParse(widget.filters.price!);
        final shipmentPrice = double.tryParse(widget.filters.price!);
        if (filterPrice != null && shipmentPrice != null && shipmentPrice > filterPrice) {
          return false;
        }
      }

      if (widget.filters.weight != null && widget.filters.weight!.isNotEmpty) {
        final filterWeight = double.tryParse(widget.filters.weight!);

        final shipmentWeight = double.tryParse(widget.filters.weight!);
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
      if (widget.filters.from != null && widget.filters.from!.isNotEmpty) {
        if (!trip.from.toLowerCase().contains(widget.filters.from!.toLowerCase())) {
          return false;
        }
      }

      // Filter by 'to' location
      if (widget.filters.to != null && widget.filters.to!.isNotEmpty) {
        if (!trip.to.toLowerCase().contains(widget.filters.to!.toLowerCase())) {
          return false;
        }
      }

      
      if (widget.filters.price != null && widget.filters.price!.isNotEmpty) {
        final filterPrice = double.tryParse(widget.filters.price!);
        final tripPrice = double.tryParse(widget.filters.price!);
        if (filterPrice != null  && tripPrice != null && tripPrice > filterPrice) {
          return false;
        }
      }

      if (widget.filters.weight != null && widget.filters.weight!.isNotEmpty) {
        final filterWeight = double.tryParse(widget.filters.weight!);
        final tripWeight= double.tryParse(widget.filters.weight!);
        if (filterWeight != null  && tripWeight != null && tripWeight < filterWeight) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.blue700,
        onPressed: () {
          context.go('/home');
        },
        child: const Icon(Icons.filter_list, color: Colors.white,),
        
      ),
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.white,
         elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black, // Change the color of the back button
          ),
          systemOverlayStyle:
              SystemUiOverlayStyle.dark, 
      ),
      body: _isSearching
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.blue700, 
                strokeWidth: 3.0,
              ),
            )
          : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Show shipments if type is null, 'Shipment', or both
                if (widget.filters.type == null || widget.filters.type == 'Shipment')
                  _buildShipmentListings(activeShipments),
                
                // Show trips if type is null, 'Trip', or both
                if (widget.filters.type == null || widget.filters.type == 'Trip')
                  _buildTripListings(activeTrips),
              ],
            ),
          ),
    );
  }



  Widget _buildEmptyShipmentsState(String message, String iconPath) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.blue700.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: CustomIcon(
              iconPath: iconPath,
              size: 60,
              color: AppColors.blue700.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
           Text(
            message,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
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
            ?  Center(child: _buildEmptyShipmentsState("No Shipments Found", 'assets/icons/package.svg'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.filters.type == null)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Shipments',
                        style: TextStyle(
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
              );
      },
    );
  }

  Widget _buildTripListings(List<Trip> activeTrips) {
    return Consumer2<TripProvider, UserProvider>(
      builder: (context, tripProvider, userProvider, child) {
        return activeTrips.isEmpty
            ?  Center(child: _buildEmptyShipmentsState("No Trips Found", 'assets/icons/car.svg'))
            : ListView.builder(
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
              );
      },
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

  // Convert to query parameters for GoRouter
  Map<String, String> toQueryParameters() {
    final Map<String, String> params = {};
    if (from != null) params['from'] = from!;
    if (price != null) params['price'] = price.toString();
    if (weight != null) params['weight'] = weight.toString();
    if (to != null) params['to'] = to!;
    if (type != null) params['type'] = type!;
    return params;
  }

  // Create from query parameters
  factory SearchFilters.fromQueryParameters(Map<String, String> params) {
    return SearchFilters(
      from: params['from'],
      price: params['price'],
      weight: params['weight'] ,
      to: params['to'] ,
      type: params['type'],
    );
  }

  

  // Copy with method for easy updates
  SearchFilters copyWith({
    String? from,
    String? price,
    String? weight,
    String? to,
    String? type,
  }) {
    return SearchFilters(
      from: from ?? this.from,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      to: to ?? this.to,
      type: type ?? this.type,
    );
  }

 
}