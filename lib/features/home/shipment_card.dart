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
        // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child:  Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusAndSender(),
                    const SizedBox(height: 16),
                    IntrinsicWidth(
                      child: _buildPriceButton(),
                    )

                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: _buildImageSection(),
              ),
            ],
        )
        ),
      ),
    );
  }

  Widget _buildStatusAndSender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        UserProfileWithRating(
            user: widget.userData,
            header: widget.userData.displayName ?? 'Guest',
            avatarSize: 32,
            headerFontSize: 12,
            onPressed: () => {}
                // {context.push('/profile/statistics?userId=${widget.user.uid}')},
          ),
        const SizedBox(height: 16),
       _buildRoute(),
      ],
    );
  }



TextSpan _textSpan(String text, Color color) => TextSpan(
      text: text,
      style: TextStyle(
        fontSize: 13,
        color: color,
        height: 1.4,
        fontWeight: FontWeight.w500,
      ),
    );

TextSpan _arrowSpan(String arrow) => TextSpan(
      text: arrow,
      style: const TextStyle(
        fontSize: 13,
        color: Colors.orange,
        height: 1.4,
        fontWeight: FontWeight.w400,
      ),
    );

Widget _buildRoute() {
  final t = AppLocalizations.of(context)!;
  final isRTL = Directionality.of(context) == TextDirection.rtl;


  final arrow = isRTL ? ' ← ' : ' → ';

  List<InlineSpan> routeSpans = [];

  // === LTR (English/French) ===
  if (!isRTL) {
    // FROM city
    routeSpans.add(_textSpan(widget.shipment.from, const Color(0xFF6A7681)));

    routeSpans.add(_arrowSpan(arrow));

    // TO city
    routeSpans.add(_textSpan(widget.shipment.to, const Color(0xFF6A7681)));
  }

  // === RTL (Arabic) ===
  else {
    // FROM city
    routeSpans.add(_textSpan(widget.shipment.from, const Color(0xFF6A7681)));

    // ← Arrow
    routeSpans.add(_arrowSpan(arrow));

    // TO city
    routeSpans.add(_textSpan(widget.shipment.to, const Color(0xFF6A7681)));
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[200]!, width: 1),
    ),
    child: RichText(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      text: TextSpan(children: routeSpans),
    ),
  );
}

  Widget _buildPriceButton() {
    return Container(
      height: 32, 
      constraints: const BoxConstraints(
        minWidth: 84,
        maxWidth: 480,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Text(
            "${widget.shipment.price} MAD",
            style: const TextStyle(
              color: Color(0xFF121416), 
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    Shipment? shipment;
    if (widget.shipment is Shipment) {
      shipment = widget.shipment as Shipment;
    }
    if (shipment == null) {
      return  Container(
          width: 110,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFE1AC71).withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(
              Icons.fire_truck,
              color: Colors.white,
              size: 40,
            ),
          ),
        
      );
    }

    return Container(
        width: 110,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: shipment.imageUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                "assets/images/box.jpg",
                fit: BoxFit.cover,
              ),
            ),
            fadeInDuration: const Duration(milliseconds: 200),
            fadeOutDuration: const Duration(milliseconds: 200),
          ),
        ),
      
    );
  }

}