import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';

class PendingRequest extends StatefulWidget {
  final DeliveryRequest request;
  final UserData user;
  final TransportItem shipment;

  const PendingRequest({
    super.key,
    required this.request,
    required this.user,
    required this.shipment,
  });

  @override
  DeliveryRequestState createState() => DeliveryRequestState();
}

class DeliveryRequestState extends State<PendingRequest> {
  void _refuseRequest() async {
    try {
      await Provider.of<DeliveryRequestProvider>(context, listen: false)
          .deleteRequest(widget.request.id!);
    } catch (e) {
      if (mounted) AppUtils.showDialog(context, "Failed to refuse request", AppColors.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeader(),
            _buildBody(),
            // const SizedBox(
            //   height: 10,
            // ),
            _buildFooter(),
          ],
        ));
  }

  Widget _buildHeader() {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: UserProfileCard(
          photoUrl: widget.user.photoUrl ?? "assets/images/profile.png",
          header: widget.user.displayName!,
          onPressed: () => {
            // context.push(
            // '/profile/${widget.user.uid}',
            // )
          },
          // subHeader: "Carrier: Ahmed K.",
          headerFontSize: 14,
          subHeaderFontSize: 10,
          avatarSize: 18,
        ));
  }

  Widget _buildBody() {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Destination(from: widget.shipment.from, to: widget.shipment.to),
          ],
        ));
  }

  Widget _buildFooter() {
    return Container(
        padding: const EdgeInsets.only(
          top: 2,
          left: 10,
          right: 10,
          bottom: 2,
        ),
        decoration: const BoxDecoration(
          color: AppColors.cardFooterBackground,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(AppTheme.cardRadius),
            bottomRight: Radius.circular(AppTheme.cardRadius),
          ),
        ),
        child: Row(
          children: [
            _buildRequestPrice(),
            const Spacer(),
            _buildButtons(),
          ],
        ));
  }

  Widget _buildButtons() {
    return Row(children: [
      ElevatedButton(
        onPressed: _refuseRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
        child: const Text(
          "Cancel",
          style: TextStyle(color: AppColors.white),
        ),
      ),
      // const SizedBox(
      //   width: 8,
      // ),
      // ElevatedButton(
      //   onPressed: () {
      //     print("Notifications clicked!");
      //   },
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: AppColors.blue,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(4),
      //     ),
      //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      //   ),
      //   child: const Text(
      //     "Negotiate",
      //     style: TextStyle(color: AppColors.white),
      //   ),
      // ),
    ]);
  }

  Widget _buildRequestPrice() {
    return Row(
      children: [
        const Text('price ',
            style: TextStyle(
                color: AppColors.headingText,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        Text('${widget.request.price} dh',
            style: const TextStyle(
                color: AppColors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
