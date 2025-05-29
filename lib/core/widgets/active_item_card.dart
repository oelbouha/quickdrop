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
              left: AppTheme.historyCardPadding * 0,
            ),
            child: Column(
              children: [
                _buildBody(),
                _buildFooter(),
              ],
            )));
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
                left: 5,
                right: 5,
                top: 3,
                bottom: 3
            ),
            decoration:  BoxDecoration(
                color: AppColors.contactBackground,
                borderRadius: BorderRadius.circular(30),
            ),
            child: const  Row(
              children: [
                CustomIcon(
                  iconPath: "assets/icon/pending.svg",
                  size: 10,
                  color: AppColors.blue,
                ),
                SizedBox(width: 5,),
                Text("Pending", style: TextStyle(fontSize: 8, color: AppColors.blue), )
            ]
        ), 
        ),
        ],),
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
    ));
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 4,
        bottom: 4,
      ),
      decoration: const BoxDecoration(
        color: AppColors.cardFooterBackground,
        borderRadius:  BorderRadius.only(
          bottomRight: Radius.circular(AppTheme.cardRadius),
          bottomLeft: Radius.circular(AppTheme.cardRadius),
        ),
      ),
      child: Row(
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
         ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cardFooterBackground,
            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: const BorderSide( 
              color: AppColors.error,
              width: 0.6, 
            ),
             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
             elevation: 0
          ),
          onPressed: widget.onPressed,
          icon: const CustomIcon(
              iconPath: "assets/icon/trash-bin.svg",
              size: 20,
              color: AppColors.error),
            label: const Text('Delete', 
              style: TextStyle(
                color: AppColors.error,
                fontSize: 14,
              )),
        ),
        const SizedBox(width: 10,),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          ),
          onPressed: () {
            print("edit clicked!");
          },
          icon: const CustomIcon(
              iconPath: "assets/icon/edit.svg",
              size: 20,
              color: AppColors.cardBackground),
            label: const Text('Edit', 
              style: TextStyle(
                color: AppColors.cardBackground,
                fontSize: 14,
              )),
        ),
      ],
    ));
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
