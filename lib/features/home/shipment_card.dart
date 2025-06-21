import 'package:quickdrop_app/features/models/base_transport.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/statictics_model.dart';

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
     final  fetchedStats = await Provider.of<StatisticsProvider>(context, listen: false)
          .getStatictics(widget.shipment.userId);
      // print(stats?.completedTrips);
      if (mounted) {
      setState(() {
        stats = fetchedStats;
      });
    }
    });
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
              // Added IntrinsicHeight
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Added this
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
    return SizedBox(
      height: 180,
      width: 130,
      child: Stack(
        children: [
          // Image with zoom effect
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(shipment.imageUrl ?? 'assets/images/box.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient overlay
          Container(
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
        onPressed: () =>  {
          context.push('/profile/statistics?userId=${widget.userData.uid}')
          },
      );
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.blue.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(21),
                child: Image.network(
                  widget.userData.photoUrl ?? AppTheme.defaultProfileImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.blue.withOpacity(0.1),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.blue,
                        size: 14,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        Expanded(
          // Added Expanded to prevent overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userData.displayName ?? "Unknown user",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.headingText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 10,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${4.5}",
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: AppColors.headingText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "•",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 8,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.local_shipping,
                    color: Colors.green,
                    size: 10,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      "${stats?.completedTrips ?? "0"} deliveries",
                      style: const TextStyle(
                        fontSize: 8,
                        color: AppColors.lessImportant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
              // const Text(
              //   "From",
              //   style: TextStyle(
              //     fontSize: 10,
              //     fontWeight: FontWeight.w500,
              //     color: AppColors.lessImportant,
              //     letterSpacing: 0.8,
              //   ),
              // ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                mainAxisSize: MainAxisSize.min, // Added this
                children: [
                  Flexible(
                    // Added Flexible for price text
                    child: Text(
                      widget.shipment.price,
                      style: const TextStyle(
                        fontSize: 32,
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
      ],
    );
  }
}
