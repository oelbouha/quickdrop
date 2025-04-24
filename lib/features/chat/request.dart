// import 'package:quickdrop_app/core/widgets/button.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Request extends StatefulWidget {
  final DeliveryRequest request;
  final Map<String, dynamic> userData;
  final Shipment shipment;

  const Request({
    super.key,
    required this.request,
    required this.userData,
    required this.shipment,
  });

  @override
  DeliveryRequestState createState() => DeliveryRequestState();
}

class DeliveryRequestState extends State<Request> {

  void _refuseRequest() async {
    try {
      await Provider.of<DeliveryRequestProvider>(context, listen: false)
          .deleteRequest(widget.request.id!);
    } catch (e) {
      if (mounted) AppUtils.showError(context, "Failed to refuse request");
    }
  }

  void _acceptRequest() async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final requestRef = FirebaseFirestore.instance
            .collection('requests')
            .doc(widget.request.id);
        final tripRef = FirebaseFirestore.instance
            .collection('trips')
            .doc(widget.request.tripId);
        final shipmentRef = FirebaseFirestore.instance
            .collection('shipments')
            .doc(widget.request.shipmentId);

        // Update the trip document
        transaction.update(tripRef, {
          'status': DeliveryStatus.ongoing,
          'matchedDeliveryId': widget.request.shipmentId,
          'matchedDeliveryUserId': widget.request.receiverId,
        });

        // Update the shipment document
        transaction.update(shipmentRef, {
          'status': DeliveryStatus.ongoing,
          'matchedDeliveryId': widget.request.shipmentId,
          'matchedDeliveryUserId': widget.request.senderId,
        });

        // Update the request document
        transaction.update(requestRef, {'status': DeliveryStatus.accepted});
        Provider.of<DeliveryRequestProvider>(context, listen: false)
            .markRequestAsAccepted(widget.request.id!);
        
        if (mounted) {
          AppUtils.showSuccess(context, "Request accepted successfully");
        }
        
      });
    } catch (e) {
      if (mounted) AppUtils.showError(context, "Failed to accept request");
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
        child: Padding(
            padding: const EdgeInsets.all(AppTheme.historyCardPadding),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeader(),
                const SizedBox(
                  height: 10,
                ),
                _buildBody(),
                const SizedBox(
                  height: 10,
                ),
                _buildFooter(),
              ],
            )));
  }

  Widget _buildHeader() {
    return Row(
      children: [
        UserProfileCard(
          photoUrl: widget.userData['photoUrl'],
          header: widget.userData['displayName'],
          onPressed: () => print("user profile  Clicked"),
          // subHeader: "Carrier: Ahmed K.",
          headerFontSize: 14,
          subHeaderFontSize: 10,
          avatarSize: 18,
        )
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Destination(from: widget.shipment.from, to: widget.shipment.to),
        const SizedBox(
          height: 8,
        ),
        _buildRequestPrice(),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        const Spacer(),
        _buildButtons(),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(children: [
      ElevatedButton(
        onPressed: _acceptRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.succes,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
        child: const Text(
          "Accept",
          style: TextStyle(color: AppColors.white),
        ),
      ),
      const SizedBox(
        width: 8,
      ),
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
          "Refuse",
          style: TextStyle(color: AppColors.white),
        ),
      ),
      const SizedBox(
        width: 8,
      ),
      ElevatedButton(
        onPressed: () {
          print("Notifications clicked!");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
        child: const Text(
          "Negotiate",
          style: TextStyle(color: AppColors.white),
        ),
      ),
    ]);
  }

  Widget _buildRequestPrice() {
    return Row(
      children: [
        Text('Starting Price: ${widget.request.price} dh',
            style: const TextStyle(
                color: AppColors.headingText,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
