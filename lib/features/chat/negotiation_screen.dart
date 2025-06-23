import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/chat/request.dart';
import 'package:quickdrop_app/features/models/chat_model.dart';
import 'package:quickdrop_app/core/providers/negotiation_provider.dart';
import 'package:quickdrop_app/features/models/negotiation_model.dart';

class NegotiationScreen extends StatefulWidget {
  final UserData user;
  final TransportItem transportItem;
  final DeliveryRequest request;

  const NegotiationScreen({
    super.key,
    required this.user,
    required this.transportItem,
    required this.request,
  });

  @override
  State<NegotiationScreen> createState() => _NegotiationScreenState();
}

class _NegotiationScreenState extends State<NegotiationScreen> {
  TextEditingController messageController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool _isProcessing = false;
  String _processingAction = '';
  String lastPrice = '';

  @override
  void initState() {
    super.initState();
    // update the message seen status when the screen is opened
    // final chatId =
    //     getChatId(FirebaseAuth.instance.currentUser!.uid, widget.user.uid);
    // Provider.of<NegotiationProvider>(context, listen: false)
    //     .markMessageAsSeen(chatId)
    //     .then((_) {
    //   // print("Message seen status updated");
    // }).catchError((error) {
    //   // print("Error updating message seen status: $error");
    // });
    lastPrice = widget.request.price.toString();
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
      }
    }
  }
  
  void _sendMessage() async {
    if (messageController.text.isEmpty) return;

    // print("user id ${widget.user.uid}");
    NegotiationModel message = NegotiationModel(
        receiverId: widget.user.uid,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        timestamp: DateTime.now().toString(),
        message: messageController.text,
        price: priceController.text,
        shipmentId: widget.transportItem.id,
        requestId: widget.request.id
      );
    try {
      await Provider.of<NegotiationProvider>(context, listen: false)
          .addMessage(message);
      setState(() {
        lastPrice = message.price;
      });
      messageController.clear();
      priceController.clear();
    } catch (e) {
      // print("Error sending message: $e");
      if (mounted)
        AppUtils.showDialog(context, "Failed to send message ${e.toString()}", AppColors.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final negotiationProvider = Provider.of<NegotiationProvider>(context);
    final chatId =
        getChatId(FirebaseAuth.instance.currentUser!.uid, widget.user.uid);

    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: UserProfileCard(
            header: widget.user.displayName ?? 'Guest',
            onPressed: () =>  {context.push('/profile/statistics?userId=${widget.user.uid}')},
            photoUrl: widget.user.photoUrl ?? AppTheme.defaultProfileImage,
            headerFontSize: 16,
            subHeaderFontSize: 10,
            avatarSize: 36,
            borderColor: AppColors.blue700,
            headerColor: AppColors.appBarText,
          ),
           iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          systemOverlayStyle:
              SystemUiOverlayStyle.dark,
          backgroundColor: AppColors.white,
           elevation: 0, 
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey, 
              height: 0.6,
            ),
          ),
        ),
        body: Column(children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppTheme.homeScreenPadding,
                    right: AppTheme.homeScreenPadding,
                    // top: 6.0,
                  ),
                  child: StreamBuilder(
                    stream: negotiationProvider.getMessages(chatId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text("Error loading messages"));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No messages yet"));
                      }
                      final messages = snapshot.data ?? [];
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId ==
                              FirebaseAuth.instance.currentUser?.uid;
                          return Column(children: [
                            Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (index == messages.length - 1) ...[
                                      const SizedBox(height: 25),
                                    ],
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 0,
                                        bottom: 5,
                                        left: isMe ? 50 : 0,
                                        right: isMe ? 0 : 50,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isMe
                                            ? AppColors.blue.withValues(alpha: 0.9)
                                            : AppColors.warning.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: _buildMessageContent(isMe, message),
                                    ),
                                    if (index == 0 && message.seen && isMe) ...[
                                      const Text(
                                        "Seen",
                                        style: TextStyle(
                                            color: AppColors.headingText,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.end,
                                      )
                                    ]
                                  ]),
                            ),
                          ]);
                        },
                      );
                    },
                  ))),
          _buildFooter(),
        ]));
  }


Widget _buildButtons() {
  return Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: (_isProcessing && _processingAction == 'accept') ? null : _acceptRequest,
                  icon: (_isProcessing && _processingAction == 'accept')
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.check_circle, size: 18),
                  label: Text(
                    (_isProcessing && _processingAction == 'accept') ? 'Accepting...' : 'Accept',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.succes,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: (_isProcessing && _processingAction == 'refuse') ? null : _refuseRequest,
                  icon: (_isProcessing && _processingAction == 'refuse')
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.error),
                          ),
                        )
                      : const Icon(Icons.close, size: 18),
                  label: Text(
                    (_isProcessing && _processingAction == 'refuse') ? 'Refusing...' : 'Refuse',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          );
}

  Widget _buildFooter() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        border: Border(
          top: BorderSide(
            color: AppColors.blue.withOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
       mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
           const Text(
          "Make an offer",
          style: TextStyle(
            color: AppColors.headingText,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFieldWithHeader(
            controller: priceController,
            hintText: "Enter your offer",
            headerText: "Price (DH)",
            keyboardType: TextInputType.number,
            maxLines: 1,
            validator: Validators.notEmpty,
           
          ),
          const SizedBox(height: 16),
          TextFieldWithHeader(
            controller: messageController,
            hintText: "Add a message",
            headerText: "Message (optional)",
            validator: Validators.notEmpty,
            keyboardType: TextInputType.text,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Button(
            hintText: "Send Offer",
            onPressed: _sendMessage,
            isLoading: false,
            backgroundColor: AppColors.blue,
            textColor: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            'Responde to: $lastPrice DH offer',
            style: const TextStyle(
              color: AppColors.headingText,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ) ,
          const SizedBox(height: 8),
          _buildButtons()
          ]
          )
      )
      );
  }
  
  
  Widget _buildMessageContent(bool isMe, NegotiationModel message) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        Text(
          'Offer: ${message.price} DH',
          style: TextStyle(
              color: isMe
                  ? Colors.white
                  : Colors.black,
                  fontWeight: FontWeight.bold
                  ),
        ),
        const SizedBox(height: 8),
        Text(
          message.message,
          style: TextStyle(
              color: isMe
                  ? Colors.white
                  : Colors.black
),
        ),
      
      ],
    );
  }



}
