import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/base_transport.dart';
export 'package:quickdrop_app/core/widgets/user_profile.dart';
import 'package:quickdrop_app/features/chat/convo_screen.dart';

class OngoingItemCard extends StatefulWidget {
  final TransportItem item;
  final UserData user;
  final VoidCallback onViewPressed;
  const OngoingItemCard({super.key, required this.item, required this.user, required this.onViewPressed});

  @override
  OngoingItemCardState createState() => OngoingItemCardState();
}

class OngoingItemCardState extends State<OngoingItemCard> {
  void _submitReview() {
    showDialog(
      context: context,
      builder: (context) {
        return ReviewDialog(
          recieverUser: widget.user,
        );
      },
    );
  }

  void _contactCourier() async {
    context.push(
      "/convo-screen",
      extra: {
        'uid': widget.user.uid,
        'displayName': widget.user.displayName ?? "Unknown user",
        'photoUrl': widget.user.photoUrl ?? AppTheme.defaultProfileImage,
      },
    );
  }

  void markShipmentAsDelivered(String id) async {
    try {
      _submitReview();
      if (widget.item is Shipment) {
        await Provider.of<ShipmentProvider>(context, listen: false)
            .updateStatus(id, DeliveryStatus.completed);
        Provider.of<StatisticsProvider>(context, listen: false)
            .incrementField(widget.item.userId, "completedShipments");
        Provider.of<StatisticsProvider>(context, listen: false)
            .decrementField(widget.item.userId, "ongoingShipments");

        // print("shipment updated succsfully");
      }
      if (widget.item is Trip) {
        await Provider.of<TripProvider>(context, listen: false)
            .updateStatus(id, DeliveryStatus.completed);
        Provider.of<StatisticsProvider>(context, listen: false)
            .incrementField(widget.item.userId, "completedTrips");
        Provider.of<StatisticsProvider>(context, listen: false)
            .decrementField(widget.item.userId, "ongoingTrips");
        // print("shipment updated succsfully");
      }
    } catch (e) {
      if (mounted) AppUtils.showDialog(context, "Failed to update shipment", AppColors.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: widget.onViewPressed, child: Container(
        // height: 120,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBody(),
            const SizedBox(
              height: 10,
            ),
            _buildFooter(),
          ],
        )));
  }

  Widget _buildHUserCard() {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.courierInfoBackground,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        child: Row(
          children: [
            UserProfileCard(
              header: widget.user.displayName ?? "Unknow user",
              onPressed: () => print("user profile  Clicked"),
              subHeader:
                  widget.item is Shipment ? "Package Carrier" : "Package owner",
              photoUrl: widget.user.photoUrl ?? AppTheme.defaultProfileImage,
              headerFontSize: 14,
              subHeaderFontSize: 10,
              avatarSize: 14,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                _contactCourier();
              },
              child: Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.contactBackground,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const CustomIcon(
                  iconPath: "assets/icon/chat-round-line.svg",
                  size: 24,
                  color: AppColors.blue,
                ),
                // label: const Text(
                //   "Contact",
                //   style: TextStyle(color: AppColors.blue, fontSize: 14),
                // ),
                // style: ElevatedButton.styleFrom(
                //   elevation: 0,
                //   backgroundColor: AppColors.contactBackground,
                //   shape: RoundedRectangleBorder(
                //     borderRadius:
                //         BorderRadius.circular(30),
                //   ),
                // padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              ),
            ),
          ],
        ));
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: AppColors.ongoingstatusBackground,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(children: [
                    CustomIcon(
                      iconPath: "assets/icon/ongoing.svg",
                      size: 10,
                      color: AppColors.ongoingStatusText,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Ongoing",
                      style: TextStyle(
                          fontSize: 8, color: AppColors.ongoingStatusText),
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
              height: 6,
            ),
            _buildHUserCard()
          ],
        ));
  }

  Widget _buildFooter() {
    return Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 4,
          bottom: 4,
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
            Text('${widget.item.price}dh',
                style: const TextStyle(
                    color: AppColors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            const Spacer(),
            _buildButtons(),
          ],
        ));
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            markShipmentAsDelivered(widget.item.id!);
          },
          icon: const CustomIcon(
            iconPath: "assets/icon/check-circle.svg",
            size: 18,
            color: Colors.white,
          ),
          label: const Text(
            "Delivered",
            style: TextStyle(color: AppColors.white, fontSize: 12),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.succes,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.cardButtonRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton.icon(
          onPressed: () {
            _contactCourier();
          },
          icon: const CustomIcon(
            iconPath: "assets/icon/cancel.svg",
            size: 18,
            color: Colors.white,
          ),
          label: const Text(
            "Cancel",
            style: TextStyle(color: AppColors.white, fontSize: 12),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.cardButtonRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          ),
        ),
      ],
    );
  }
}
