// import 'package:quickdrop_app/core/widgets/button.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';

  

class Request extends StatefulWidget {
  final DeliveryRequest request;
  final UserData user;
  final Shipment shipment;

  const Request({
    super.key,
    required this.request,
    required this.user,
    required this.shipment,
  });

  @override
  RequestState createState() => RequestState();
}

class RequestState extends State<Request> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isProcessing = false;
  String _processingAction = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _refuseRequest() async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
      _processingAction = 'refuse';
    });
    
    try {
      await Provider.of<DeliveryRequestProvider>(context, listen: false)
          .deleteRequest(widget.request.id!);
      
      if (mounted) {
        AppUtils.showDialog(context, "Request refused successfully", AppColors.succes);
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showDialog(context, "Failed to refuse request", AppColors.error);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _processingAction = '';
        });
      }
    }
  }

  void _acceptRequest() async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
      _processingAction = 'accept';
    });
    _animationController.forward();
    
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

         final tripDoc = await tripRef.get();
        final shipmentDoc = await shipmentRef.get();

        final tripData = tripDoc.data();
        final shipmentData = shipmentDoc.data();

        if (tripData != null && shipmentData != null) {
          final tripWeight = double.tryParse(tripData['weight'].toString()) ?? 0.0;
          final shipmentWeight = double.tryParse(shipmentData['weight'].toString()) ?? 0.0;

          final weight = tripWeight - shipmentWeight;

          if (weight == 0) {
            // Update the trip document
            transaction.update(tripRef, {
              'status': DeliveryStatus.ongoing,
              'matchedDeliveryId': widget.request.shipmentId,
              'matchedDeliveryUserId': widget.request.receiverId,
              'price': widget.request.price
            });
            
          } else {
            // Create a new trip with same details but updated weight
            final newTripRef = FirebaseFirestore.instance.collection('trips').doc();

            transaction.set(newTripRef, {
              ...tripData, 
              'weight': shipmentWeight.toString(),
              'status': DeliveryStatus.ongoing,
               'matchedDeliveryId': widget.request.shipmentId,
              'matchedDeliveryUserId': widget.request.receiverId,
            });
            transaction.update(tripRef, {
              'weight': weight.toString(), 
            });
        }
          
        }

        // Update the shipment document
        transaction.update(shipmentRef, {
          'status': DeliveryStatus.ongoing,
          'matchedDeliveryId': widget.request.shipmentId,
          'matchedDeliveryUserId': widget.request.senderId,
          'price': widget.request.price
        });

        // Update the request document
        final requestProvider =
            Provider.of<DeliveryRequestProvider>(context, listen: false);
        transaction.update(requestRef, {'status': DeliveryStatus.accepted});
        requestProvider.markRequestAsAccepted(widget.request.id!);

        if (mounted) {
          AppUtils.showDialog(
              context, "Request accepted successfully", AppColors.succes);
          await requestProvider.deleteActiveRequestsByShipmentId(
              widget.request.shipmentId, widget.request.id!);
          Provider.of<StatisticsProvider>(context, listen: false)
              .incrementField(widget.request.receiverId, "ongoingShipments");
          Provider.of<StatisticsProvider>(context, listen: false)
              .decrementField(widget.request.receiverId, "pendingShipments");
          Provider.of<StatisticsProvider>(context, listen: false)
              .incrementField(widget.request.senderId, "ongoingTrips");
          Provider.of<StatisticsProvider>(context, listen: false)
              .decrementField(widget.request.senderId, "pendingTrips");
        }
      });
    } catch (e) {
      if (mounted) {
        AppUtils.showDialog(context, "Failed to accept request", AppColors.error);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _processingAction = '';
        });
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.cardBackground,
                  AppColors.cardBackground.withValues(alpha: 0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  spreadRadius: 0,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildStatusBanner(),
                _buildHeader(),
                _buildBody(),
                _buildFooter(),
              ],
            ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_shipping,
              size: 14,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'New Delivery Request',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
         


Widget _buildHeader() {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: UserProfileWithRating(
          user: widget.user,
          header: widget.user.displayName ?? 'Guest',
          avatarSize: 40,
          headerFontSize: 16,
          subHeaderFontSize: 12,
          onPressed: () =>
              {context.push('/profile/statistics?userId=${widget.user.uid}')},
        ));
  }



  Widget _buildBody() {
    return Padding(
        padding: const EdgeInsets.all(16),
      child:  Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
          child: Destination(
            from: widget.shipment.from,
            to: widget.shipment.to,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: buildPriceCard(price: widget.request.price, label: 'Offered Price')),
      ],
    ));
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: 
          Row(
            children: [
              Expanded(
                child: Container(
                width: 200,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.push('/negotiation-screen?userId=${widget.user.uid}&shipmentId=${widget.shipment.id}&requestId=${widget.request.id}');
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Negotiate'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  ),
                ),
              ),
              ),
              const SizedBox(width: 8),
                BuildSecondaryButton(
              icon: "assets/icon/eye.svg",
              onPressed: () => {
                 context.push('/shipment-details?shipmentId=${widget.shipment.id}&userId=${widget.shipment.userId}&viewOnly=true')          
              },
            ),
            const SizedBox(width: 8),
              ElevatedButton(
                  onPressed: (_isProcessing && _processingAction == 'accept') ? null : _acceptRequest,
                 style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.succes,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                  elevation: 0,
                ),
                  child: (_isProcessing && _processingAction == 'accept')
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.error),
                          ),
                        )
                      : const Icon(Icons.done, size: 18),
                
              ),
              const SizedBox(width: 8),
               ElevatedButton(
                  onPressed: (_isProcessing && _processingAction == 'refuse') ? null : _refuseRequest,
                 style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  elevation: 0,
                ),
                  child: (_isProcessing && _processingAction == 'refuse')
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.error),
                          ),
                        )
                      : const Icon(Icons.close, size: 18),
                
              ),
              
            ],
          ),
    );
  }


}