
import 'package:quickdrop_app/features/models/base_transport.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

class ShipmentCard extends StatefulWidget {
  final TransportItem shipment;
  // final Shipment shipment;
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
  bool isLiked = false;
  bool isSaved = false;
  bool isHovered = false;

  @override
  void dispose() {
    super.dispose();
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
              color: isHovered
                  ? AppColors.blue.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              width: isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isHovered
                    ? AppColors.blue.withOpacity(0.15)
                    : Colors.black.withOpacity(0.08),
                blurRadius: isHovered ? 20 : 8,
                offset: Offset(0, isHovered ? 8 : 4),
                spreadRadius: isHovered ? 2 : 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            
            child: Row(
              children: [
                _buildImageSection(),
                const SizedBox(width: 4),
                Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 2,
                      top: 12,
                      bottom: 4,
                    ),
                    child: _buildContentSection()),
              ],
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

          // Top row - Status badges and actions
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

          //
        ],
      ),
    );
  }

  Widget _buildStatusBadge(
      String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
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

  Widget _buildUrgentBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.red, Colors.orange],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.flash_on,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          const Text(
            "Urgent",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    bool isActive,
    Color activeColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          isActive && icon == Icons.favorite
              ? Icons.favorite
              : isActive && icon == Icons.bookmark
                  ? Icons.bookmark
                  : icon == Icons.favorite
                      ? Icons.favorite_border
                      : Icons.bookmark_border,
          color: isActive ? Colors.white : Colors.grey[600],
          size: 18,
        ),
      ),
    );
  }

  Widget _buildVerificationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          const Text(
            "Verified",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserProfile(),
        const SizedBox(height: 8),
        _buildDestination(),
        const SizedBox(height: 4),
        _buildDetailsGrid(),
        const SizedBox(height: 6),
        _buildPriceAndAction(),
      ],
    );
  }

  Widget _buildUserProfile() {
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.userData.displayName ?? "Unknown user",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.headingText,
              ),
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
                  Icons.trending_up,
                  color: Colors.green,
                  size: 10,
                ),
                const SizedBox(width: 4),
                Text(
                  "${0} deliveries",
                  style: const TextStyle(
                    fontSize: 8,
                    color: AppColors.lessImportant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDestination() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFromDestination(),
        const SizedBox(
          width: 8,
        ),
        const CustomIcon(
            iconPath: "assets/icon/arrow-up-right.svg",
            size: 14,
            color: AppColors.lessImportant),
        // Spacer(),
        const SizedBox(
          width: 8,
        ),
        _buildToDestination(),
      ],
    );
  }

  Widget _buildFromDestination() {
    return Row(
      children: [
        const Icon(
          Icons.circle,
          size: 12,
          color: AppColors.blue700,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(truncateText(widget.shipment.from),
            style: const TextStyle(
                color: AppColors.headingText,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildToDestination() {
    return Row(
      children: [
        const Icon(
          Icons.circle,
          size: 12,
          color: AppColors.purple700,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(truncateText(widget.shipment.to),
            style: const TextStyle(
                color: AppColors.headingText,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDetailsGrid() {
    Shipment? shipment;
    Trip? trip;
    if (widget.shipment is Shipment) {
      shipment = widget.shipment as Shipment;
    }
    else if (widget.shipment is Trip) {
      trip = widget.shipment as Trip;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildDetailCard(
          "assets/icon/time.svg",
          "DELIVERY",
          widget.shipment.date,
          AppColors.blue,
        ),
        // const SizedBox(width: 12),
        if (trip != null)
          _buildDetailCard(
          "assets/icon/weight.svg",
          "AVAILABLE WEIGHT",
          "${trip.weight} kg",
          Colors.purple,
        ),
        if (shipment != null)
        _buildDetailCard(
          "assets/icon/weight.svg",
          "WEIGHT",
          "${shipment.weight} kg",
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildDetailCard(
      String icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomIcon(
          iconPath: icon,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.headingText,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndAction() {
    Trip? trip;
   if (widget.shipment is Trip) {
      trip = widget.shipment as Trip;
    }
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "STARTING FROM",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.lessImportant,
                letterSpacing: 0.8,
              ),
            ),
            // const SizedBox(height: 2),
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
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
        const SizedBox(width: 70),
        if (trip != null)
        Positioned(
          right: 0,
          bottom: 16,
          child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.blue, Colors.purple],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              "Make Offer",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )),
      ],
    );
  }


}
