import 'package:cached_network_image/cached_network_image.dart';
import 'package:quickdrop_app/features/models/base_transport.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/statictics_model.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ShipmentCard extends StatefulWidget {
  final TransportItem shipment;
  final UserData userData;
  final VoidCallback onPressed;
  final VoidCallback? onLike;
  final VoidCallback? onSave;
  final VoidCallback? onMakeOffer;

  const ShipmentCard({
    super.key,
    required this.shipment,
    required this.userData,
    required this.onPressed,
    this.onLike,
    this.onSave,
    this.onMakeOffer,
  });

  @override
  ShipmentCardState createState() => ShipmentCardState();
}

class ShipmentCardState extends State<ShipmentCard>
    with TickerProviderStateMixin {
  late StatisticsModel? stats;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
       _precacheImages();
      final fetchedStats =
          await Provider.of<StatisticsProvider>(context, listen: false)
              .getStatictics(widget.shipment.userId);
              
      // print(stats?.completedTrips);
      if (mounted) {
        setState(() {
          stats = fetchedStats;
        });
      }
    });
  }

  Future<void> _precacheImages() async {
    Shipment? shipment;
    if (widget.shipment is Shipment) {
      shipment = widget.shipment as Shipment;
    }
    if (shipment == null) {
      return;
    }
    if (shipment.imageUrl != null) {
      try {
        await DefaultCacheManager().downloadFile(
          shipment.imageUrl!,
        );
      } catch (e) {
        print('Failed to precache image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.grey.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch, 
                children: [
                  _buildImageSection(),
                  Expanded(
                    // Wrapped in Expanded to constrain width
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildContentSection(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildImageSection() {
    Shipment? shipment;
    if (widget.shipment is Shipment) {
      shipment = widget.shipment as Shipment;
    }
    if (shipment == null) {
      return const SizedBox.shrink();
    }
    
    // Fixed: Always maintain consistent container dimensions
    return Container(
      height: 215,
      width: 130,
      child: Stack(
        children: [
          // Fixed: Use a consistent placeholder that maintains dimensions
          Container(
            width: 130,
            height: 215,
            decoration: BoxDecoration(
              color: AppColors.blueStart.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              child: CachedNetworkImage(
                imageUrl: shipment.imageUrl!,
                fit: BoxFit.cover,
                width: 130,
                height: 215,
                // Fixed: Use memCacheWidth and memCacheHeight for consistent sizing
                memCacheWidth: (130 * MediaQuery.of(context).devicePixelRatio).round(),
                memCacheHeight: (215 * MediaQuery.of(context).devicePixelRatio).round(),
                placeholder: (context, url) => Container(
                  width: 130,
                  height: 215,
                  decoration: BoxDecoration(
                    color: AppColors.blueStart.withValues(alpha: 0.1),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blue700, 
                      strokeWidth: 2
                    )
                  )
                ),
                errorWidget: (context, url, error) => Container(
                  width: 130,
                  height: 215,
                  decoration: BoxDecoration(
                    color: AppColors.blueStart.withValues(alpha: 0.1),
                  ),
                  child: Image.asset(
                    "assets/images/box.jpg",
                    fit: BoxFit.cover,
                    width: 130,
                    height: 215,
                  )
                ),
                // Fixed: Add fadeInDuration to reduce visual jump
                fadeInDuration: const Duration(milliseconds: 200),
                // Fixed: Add fade out duration for smooth transitions
                fadeOutDuration: const Duration(milliseconds: 200),
              ),
            ),
          ),
          // Gradient overlay
          Container(
            width: 130,
            height: 215,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Status badge
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildStatusBadge(
                      shipment.type,
                      Colors.white.withOpacity(0.6),
                      Colors.grey[700]!,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(
      String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildUserProfile(),
            const SizedBox(height: 12),
            _buildDestination(),
            const SizedBox(height: 12),
            _buildDetailsGrid(),
          ],
        ),
        const SizedBox(height: 8),
        _buildPriceAndAction(),
      ],
    );
  }

  Widget _buildUserProfile() {
    return UserProfileWithRating(
      user: widget.userData,
      header: widget.userData.displayName ?? 'Guest',
      avatarSize: 34,
      headerFontSize: 10,
      subHeaderFontSize: 8,
      onPressed: () =>
          {context.push('/profile/statistics?userId=${widget.userData.uid}')},
    );
  }

  Widget _buildDestination() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          _buildLocationPoint(
            widget.shipment.from,
            AppColors.blue700,
            true,
          ),
          Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.blue700, AppColors.purple700],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          _buildLocationPoint(
            widget.shipment.to,
            AppColors.purple700,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPoint(String location, Color color, bool isFrom) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          truncateText(location, maxLength: 8),
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsGrid() {
    Shipment? shipment;
    Trip? trip;
    if (widget.shipment is Shipment) {
      shipment = widget.shipment as Shipment;
    } else if (widget.shipment is Trip) {
      trip = widget.shipment as Trip;
    }

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _buildDetailChip(
          Icons.schedule,
          widget.shipment.date,
          AppColors.blue,
        ),
        if (trip != null)
          _buildDetailChip(
            Icons.inventory,
            "${trip.weight} kg available",
            Colors.purple,
          ),
        if (shipment != null)
          _buildDetailChip(
            Icons.scale,
            "${shipment.weight} kg",
            Colors.purple,
          ),
      ],
    );
  }

  Widget _buildViewDetailsButton() {
    return GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.blue700.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.blue700.withOpacity(0.2)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Request",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dark,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: AppColors.blue700,
              ),
            ],
          ),
        ));
  }

  Widget _buildDetailChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceAndAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          // Changed to Flexible to prevent overflow
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    // Added Flexible for price text
                    child: Text(
                      widget.shipment.price,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "dh",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // const Spacer(),
        _buildViewDetailsButton(),
      ],
    );
  }
}