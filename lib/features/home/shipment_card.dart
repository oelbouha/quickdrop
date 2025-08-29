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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Container(
            height: 280,
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: _buildBackgroundImage(),
                ),
                
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.8),
                        ],
                        stops: const [0.0, 0.4, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
                
                // Top Row - Status Badge and Bookmark
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusBadge(),
                      if (widget.onSave != null)
                        GestureDetector(
                          onTap: widget.onSave,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.bookmark_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
               
                
                // Bottom Content
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24),

                    ),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location
                     
                      
                      // Bottom Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Price
                          Text(
                            "${widget.shipment.price} MAD",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          
                          // Date
                          const Text(
                            "Aug 22-27", 
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      // Initiated by row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(
                              "${widget.shipment.from} → ${widget.shipment.to}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                widget.userData.firstName ?? 'Unknown',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildUserAvatar(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    Shipment? shipment;
    if (widget.shipment is Shipment) {
      shipment = widget.shipment as Shipment;
    }

    return shipment?.imageUrl != null
        ? CachedNetworkImage(
            imageUrl: shipment!.imageUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: const Color(0xFF87CEEB),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF87CEEB),
                    Color(0xFF4682B4),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.local_shipping,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
          )
        : Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF87CEEB),
                  Color(0xFF4682B4),
                ],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.local_shipping,
                color: Colors.white,
                size: 48,
              ),
            ),
          );
  }

  Widget _buildStatusBadge() {
    String shipmentType = "Express"; // Replace with widget.shipment.type
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.public,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            "Public",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselDot(bool isActive) {
    return Container(
      width: isActive ? 8 : 6,
      height: isActive ? 8 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.orange.shade400,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          (widget.userData.displayName?.isNotEmpty == true)
              ? widget.userData.displayName![0].toUpperCase()
              : 'U',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}