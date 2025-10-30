
import 'package:quickdrop_app/core/utils/imports.dart';

class ActiveItemCard extends StatefulWidget {
  final TransportItem item;
  final VoidCallback onPressed; // Delete callback
  final VoidCallback onEditPressed;
  final VoidCallback onViewPressed;

  const ActiveItemCard({
    super.key,
    required this.item,
    required this.onPressed,
    required this.onEditPressed,
    required this.onViewPressed,
  });

  @override
  State<ActiveItemCard> createState() => _ActiveItemCardState();
}

class _ActiveItemCardState extends State<ActiveItemCard> {
  bool _expandedStops = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
          border: Border.all(
            color: AppColors.cardBackground.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  BuildHeader(
                      from: widget.item.from,
                      to: widget.item.to,
                      id: widget.item.id,
                      price: widget.item.price),
                  const SizedBox(height: 16),
                  buildShipmentBody(context, widget.item.date, widget.item.weight ),
                ])),
            _buildMiddleStops(),
            _buildFooter(),
          ],
        ));
  }

 

  Widget _buildFooter() {
    final t = AppLocalizations.of(context)!;
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
        child: Row(
          children: [
            Expanded(
              child: BuildPrimaryButton(
                  onPressed: widget.onViewPressed,
                  label: t.view_details,
                  color: Theme.of(context).colorScheme.secondary,
                  icon: "assets/icon/eye.svg"),
            ),
            const SizedBox(width: 12),
            SecondaryButton(
              icon: "assets/icon/edit.svg",
              onPressed: widget.onEditPressed,
              iconColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            SecondaryButton(
              icon: "assets/icon/trash-bin.svg",
              onPressed: widget.onPressed,
              iconColor: AppColors.error,
            ),
          ],
        ));
  }

  Widget _buildMiddleStops() {
    if (widget.item is! Trip) {
      return const SizedBox.shrink();
    }

    final trip = widget.item as Trip;
    if (trip.middleStops == null || trip.middleStops!.isEmpty) {
      return const SizedBox.shrink();
    }

    final hasMultipleStops = trip.middleStops!.length > 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.blue.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CustomIcon(
                iconPath: "assets/icon/location.svg",
                size: 16,
                color: AppColors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                '${AppLocalizations.of(context)!.stops} (${trip.middleStops!.length})',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              // First Stop
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      trip.middleStops![0],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  if (hasMultipleStops)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _expandedStops = !_expandedStops;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 8),
                        child: CustomIcon(
                          iconPath: _expandedStops
                              ? "assets/icon/chevron-up.svg"
                              : "assets/icon/chevron-down.svg",
                          size: 18,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                ],
              ),
              // Additional Stops (Expanded)
              if (hasMultipleStops && _expandedStops) ...[
                const SizedBox(height: 12),
                ...List.generate(
                  trip.middleStops!.length - 1,
                  (index) {
                    final actualIndex = index + 1;
                    final stop = trip.middleStops![actualIndex];
                    final isLast = actualIndex == trip.middleStops!.length - 1;

                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppColors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                stop,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (!isLast)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 2,
                              top: 6,
                              bottom: 6,
                            ),
                            child: Container(
                              width: 2,
                              height: 16,
                              color: AppColors.blue.withOpacity(0.2),
                            ),
                          ),
                        if (!isLast) const SizedBox(height: 12),
                      ],
                    );
                  },
                ),
              ] else if (hasMultipleStops) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 2,
                      height: 8,
                      color: AppColors.blue.withOpacity(0.2),
                      margin: const EdgeInsets.only(left: 2),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '+${trip.middleStops!.length - 1} ${AppLocalizations.of(context)!.more}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}


  Widget _buildInfoColumn({required String label, required String value}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF111827),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }


 Widget buildShipmentBody(BuildContext context, String date, String weight) {
    final t = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _buildInfoColumn(
            label: t.date,
            value: date,
          ),
        ),
        Container(
          width: 1,
          height: 40,
          color: const Color(0xFFE5E7EB),
        ),
        Expanded(
          child: _buildInfoColumn(
            label: t.weight,
            value: '$weight ${t.kg}',
          ),
        ),
      ],
    );
  }
