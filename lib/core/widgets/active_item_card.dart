import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/base_transport.dart';

class ActiveItemCard extends StatefulWidget {
  final TransportItem item;
  final VoidCallback onPressed;
  const ActiveItemCard({
    super.key, 
    required this.item,
    required this.onPressed,
    });

  @override
  ActiveListing createState() => ActiveListing();
}

class ActiveListing extends State<ActiveItemCard> {
  

  @override
  Widget build(BuildContext context) {
    return Container(
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
              left: AppTheme.historyCardPadding,
            ),
            child: Column(
              children: [
                _buildBody(),
                _buildFooter(),
              ],
            )));
  }

  Widget _buildBody() {
    return Column(
      children: [
        Row(children: [
          Destination(from: widget.item.from, to: widget.item.to),
          const Spacer(),
          IconButton(
            icon: const CustomIcon(
                iconPath: "assets/icon/trash-bin.svg",
                size: 20,
                color: AppColors.error),
            onPressed: widget.onPressed,
          )
        ]),
        const SizedBox(
          height: 3,
        ),
        buildIconWithText(
          iconPath: "calendar.svg", 
          text: 'Departure time ${widget.item.date}'
        ),
        const SizedBox(
          height: 3,
        ),
        buildIconWithText(
          iconPath: "weight.svg", 
          text: 'Weight ${widget.item.weight} kg'
        ),
        const SizedBox(
          height: 3,
        ),
        _buildType(),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Text(' ${widget.item.price}dh',
            style: const TextStyle(
                color: AppColors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        const SizedBox(
          width: 10,
        ),
        const Spacer(),
        IconButton(
          icon: const CustomIcon(
              iconPath: "assets/icon/edit.svg",
              size: 20,
              color: AppColors.lessImportant),
          onPressed: () {
            // Navigate to notifications page or show a dialog
            print("Notifications clicked!");
          },
        )
      ],
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
            color: AppColors.lessImportant,
          ),
          Text('  ${shipment.type}', // Now using `shipment.type`
              style:
                  const TextStyle(color: AppColors.headingText, fontSize: 10)),
        ],
      );
    }
    return const SizedBox
        .shrink(); // If it's not a Shipment, return an empty widget
  }
}
