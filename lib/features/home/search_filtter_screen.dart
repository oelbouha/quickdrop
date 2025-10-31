import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';



class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  SearchFilterScreenState createState() => SearchFilterScreenState();
}

class SearchFilterScreenState extends State<SearchFilterScreen>
    with TickerProviderStateMixin {
  bool _isSearching = false;

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final weightController = TextEditingController();
  final priceController = TextEditingController();
  final typeController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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

  Widget _buildFilterTypeSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: weightController,
                  hintText: "1.0",
                  label: "Weight (kg)",
                  isRequired: false,
                  displayLabel: true,
                  keyboardType: TextInputType.number,
                  validator: Validators.notEmpty(context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  controller: priceController,
                  hintText: "1.0",
                  label: "price (dh)",
                  isRequired: false,
                  displayLabel: true,
                  keyboardType: TextInputType.number,
                  validator: Validators.notEmpty(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Select Type",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TypeSelectorWidget(
            onTypeSelected: (type) {
              typeController.text = type;
            },
            initialSelection: "Shipment",
            types: const ["Shipment", "Trip"],
            selectedColor: AppColors.blue600,
            unselectedColor: AppColors.textSecondary,
            topSpacing: 0, // Explicitly set to 0 to remove any top padding
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterDestination(),
        ],
      ),
    );
  }

  Widget _buildFilterDestination() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: fromController,
          hintText: "Departure city",
          label: "From",
          validator: Validators.notEmpty(context),
          isRequired: false,
          iconPath: "assets/icon/map-point.svg",
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: toController,
          isRequired: false,
          hintText: "Destination city",
          label: "To",
          validator: Validators.notEmpty(context),
          iconPath: "assets/icon/map-point.svg",
        ),

        // const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: OutlinedButton.icon(
            onPressed: _clearSearchFilter,
            icon: const Icon(Icons.clear_all, size: 18, color: Colors.black),
            label: const Text('Clear',
                style: TextStyle(fontSize: 16, color: Colors.black)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: ElevatedButton.icon(
            onPressed: _isSearching ? null : _performSearch,
            icon: _isSearching
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.search, size: 18),
            label: Text(_isSearching ? 'Searching...' : 'Search',
                style: const TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  void _clearSearchFilter() {
    setState(() {
      fromController.clear();
      toController.clear();
      weightController.clear();
      priceController.clear();
      typeController.text = "Shipment";
    });
  }

  void _performSearch() async {
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

    // Create filters from form input
    SearchFilters filters = SearchFilters(
      from: fromController.text.isEmpty ? null : fromController.text,
      to: toController.text.isEmpty ? null : toController.text,
      price: priceController.text.isEmpty ? null : priceController.text,
      weight: weightController.text.isEmpty ? null : weightController.text,
      type: typeController.text.isEmpty ? "Shipment" : typeController.text,
    );

    // Navigate to results page
    // await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => SearchResultsScreen(filters: filters),
    //   ),
    // );

    setState(() {
      _isSearching = false;
    });
  }

  Widget _buildSliverApp() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title:  Text(
        AppLocalizations.of(context)!.search,
        style: TextStyle(
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverApp(),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  _buildFilterSection(),
                  const SizedBox(height: 16),
                  _buildFilterTypeSection(),
                ])),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _buildFilterButtons(),
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

