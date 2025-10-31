import 'package:quickdrop_app/features/models/base_transport.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/statictics_model.dart';

class TripCard extends StatefulWidget {
  final Trip shipment;
  final UserData userData;
  final VoidCallback onPressed;

  const TripCard({
    super.key,
    required this.shipment,
    required this.userData,
    required this.onPressed,
  });

  @override
  TripCardState createState() => TripCardState();
}

class TripCardState extends State<TripCard> {
  late StatisticsModel? stats;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSenderProfile(),
              const SizedBox(height: 16),
              _buildRoute(),
              const SizedBox(height: 16),
              _buildDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSenderProfile() {
    return Row(
      children: [
        UserProfileWithRating(
          user: widget.userData,
          header: widget.userData.displayName ?? 'Guest',
          avatarSize: 44,
          headerFontSize: 14,
          onPressed: () =>
              context.push('/profile/statistics?userId=${widget.userData.uid}'),
        )
      ],
    );
  }

  Widget _buildRoute() {
  final t = AppLocalizations.of(context)!;
  final isRTL = Directionality.of(context) == TextDirection.rtl;

  List<String> stops = widget.shipment.middleStops ?? [];
  bool hasManyStops = stops.length > 3;
  List<String> displayStops = hasManyStops ? stops.sublist(0, 2) : stops;


  final arrow = ' → ';

  List<InlineSpan> routeSpans = [];

  if (!isRTL) {
    // FROM city
    routeSpans.add(_textSpan(widget.shipment.from, const Color(0xFF6A7681)));

    // MIDDLE stops
    for (int i = 0; i < displayStops.length; i++) {
      routeSpans.add(_arrowSpan(arrow));
      routeSpans.add(_textSpan(displayStops[i], Colors.orange));
    }

    // +N more
    if (hasManyStops) {
      routeSpans.add(_textSpan(' +${stops.length - 2} ${t.more}', Colors.orange));
    }

    
    routeSpans.add(_arrowSpan(arrow));

    // TO city
    routeSpans.add(_textSpan(widget.shipment.to, const Color(0xFF6A7681)));
  }

  
  else {
    // FROM city
    routeSpans.add(_textSpan(widget.shipment.from, const Color(0xFF6A7681)));

    
    routeSpans.add(_arrowSpan(arrow));

    // MIDDLE stops
    for (int i = 0; i < displayStops.length; i++) {
      routeSpans.add(_textSpan(displayStops[i], Colors.orange));
      routeSpans.add(_arrowSpan(arrow));
    }

    if (hasManyStops) {
      routeSpans.add(_textSpan('+${stops.length - 2} ${t.more} ', Colors.orange));
      routeSpans.add(_arrowSpan(arrow));
    }

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



  Widget _buildDetails() {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Available Weight
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  size: 16,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.available_weight,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${widget.shipment.weight ?? '0'} ${t.kg}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF121416),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Pickup Date
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.pickup_date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _formatDate(widget.shipment.date != null
                            ? DateTime.tryParse(widget.shipment.date!)
                            : null),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF121416),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final month = date.month > 9 ? date.month : '0${date.month}';
    final day = date.day > 9 ? date.day : '0${date.day}';
    return '$month/$day';
  }
}