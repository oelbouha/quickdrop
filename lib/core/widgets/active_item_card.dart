import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/base_transport.dart';

class ActiveItemCard extends StatefulWidget {
  final TransportItem item;
  final VoidCallback onPressed;
  
  final VoidCallback onViewPressed;
  const ActiveItemCard({
    super.key,
    required this.item,
    required this.onPressed,
    required this.onViewPressed
  });

  @override
  ActiveListing createState() => ActiveListing();
}

class ActiveListing extends State<ActiveItemCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onViewPressed, 
        child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.2,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
            padding: const EdgeInsets.only(
              left: AppTheme.historyCardPadding * 0,
            ),
            child: Column(
              children: [
                _buildBody(),
                _buildFooter(),
              ],
            ))));
  }

  Widget _buildBody() {
    return Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 4,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Destination(from: widget.item.from, to: widget.item.to),
                Container(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 3, bottom: 3),
                  decoration: BoxDecoration(
                    color: AppColors.contactBackground,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(children: [
                    CustomIcon(
                      iconPath: "assets/icon/pending.svg",
                      size: 10,
                      color: AppColors.blue,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Pending",
                      style: TextStyle(fontSize: 8, color: AppColors.blue),
                    )
                  ]),
                ),
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            buildIconWithText(
                iconPath: "calendar.svg",
                text: 'Departure time ${widget.item.date}'),
            const SizedBox(
              height: 3,
            ),
            buildIconWithText(
                iconPath: "weight.svg",
                text: 'Weight ${widget.item.weight} kg'),
            const SizedBox(
              height: 3,
            ),
            _buildType(),
          ],
        ));
  }

  Widget _showPopUpMenu() {
    return Theme(
        data: Theme.of(context).copyWith(
          popupMenuTheme: PopupMenuThemeData(
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        child: PopupMenuButton<int>(
          onSelected: (value) {
            // setState(() {
            //    = value;
            // });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            const PopupMenuItem<int>(
              value: 0,
              child: Row(
                children: [
                  CustomIcon(
                    iconPath: "assets/icon/package.svg",
                    size: 20,
                    color: AppColors.blue600,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'edit',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuItem<int>(
              value: 1,
              child: Row(
                children: [
                  CustomIcon(
                    iconPath: "assets/icon/car.svg",
                    size: 20,
                    color: AppColors.blue600,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'delete',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }


Widget _buildFooter() {
  return Container(
    padding: const EdgeInsets.only(
      left: 8,
      right: 8,
      top: 14,
      bottom: 14,
    ),
    decoration: const BoxDecoration(
      color: AppColors.cardFooterBackground,
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(AppTheme.cardRadius),
        bottomLeft: Radius.circular(AppTheme.cardRadius),
      ),
    ),
    child: Row(
      children: [
        Text(
          ' ${widget.item.price}dh',
          style: const TextStyle(
            color: AppColors.blue,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        const Spacer(),
        GestureDetector(
          onTap: () {
            // Get the position of the GestureDetector
            final RenderBox button = context.findRenderObject() as RenderBox;
            final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
            // Calculate the position to place the menu below and aligned with the right edge of the icon
            final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
            final double menuWidth = 120; // Approximate menu width (adjust as needed)
            final RelativeRect position = RelativeRect.fromLTRB(
              buttonPosition.dx + button.size.width - menuWidth, // Left: Align menu's right edge with icon's right edge
              buttonPosition.dy + button.size.height, // Top: Just below the icon
              buttonPosition.dx + button.size.width, // Right: Icon's right edge
              buttonPosition.dy, // Bottom: Adjusted to ensure proper anchoring
            );

            showMenu<int>(
              context: context, // Use the widget's BuildContext
              position: position,
              items: <PopupMenuEntry<int>>[
                const PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      CustomIcon(
                        iconPath: "assets/icon/edit.svg",
                        size: 20,
                        color: AppColors.blue600,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child:  Row(
                    children: [
                      CustomIcon(
                        iconPath: "assets/icon/trash-bin.svg",
                        size: 20,
                        color: AppColors.blue600,
                      ),
                      SizedBox(width: 8),
                       Text(
                        'Delete',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: AppColors.white,
            ).then((value) {
              if (value != null) {
                if (value == 0) {
                    
                } else if (value == 1) {
                  widget.onPressed(); 
                }
              }
            });
          },
          child: const CustomIcon(
            iconPath: "assets/icon/dots.svg",
            size: 18,
            color: AppColors.dark,
          ),
        ),
      ],
    ),
  );
}
  Widget _buildType() {
    if (widget.item is Shipment) {
      final shipment = widget.item as Shipment;
      return Row(
        children: [
          const CustomIcon(
            iconPath: "assets/icon/package.svg",
            size: 12,
            color: AppColors.shipmentText,
          ),
          Text(' ${shipment.type}', // Now using `shipment.type`
              style:
                  const TextStyle(color: AppColors.shipmentText, fontSize: 10)),
        ],
      );
    }
    return const SizedBox
        .shrink(); // If it's not a Shipment, return an empty widget
  }
}
