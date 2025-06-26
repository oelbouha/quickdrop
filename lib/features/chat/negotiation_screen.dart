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


enum NegotiationTurn { sender, receiver }
enum NegotiationStatus { pending, accepted, rejected, expired }


class NegotiationScreen extends StatefulWidget {
  final String userId;
  final String requestId;
  final String shipmentId;  

  const NegotiationScreen({
    super.key,
    required this.userId,
    required this.requestId,
    required this.shipmentId
  });

  @override
  State<NegotiationScreen> createState() => _NegotiationScreenState();
}



class _NegotiationScreenState extends State<NegotiationScreen> {


Future<(UserData, TransportItem, DeliveryRequest)> fetchData() async {
  print("fetching data");
  print("shipment id: ${widget.shipmentId}");
  print("request id: ${widget.requestId}");
  final user = Provider.of<UserProvider>(context, listen: false).getUserById(widget.userId);;
  final transportItem = await Provider.of<ShipmentProvider>(context, listen: false).fetchShipmentById(widget.shipmentId);
  final request = await Provider.of<DeliveryRequestProvider>(context, listen: false).fetchRequestById(widget.requestId);
  if (user == null || transportItem == null || request == null) {
    if (request == null) print("request not found");
    if (transportItem == null) print("shipment not found");
    if (user == null) print("user not found");
    return Future.error("Data not found");}
  return (user, transportItem, request);
}

@override
Widget build(BuildContext context) {
  return FutureBuilder<(UserData, TransportItem, DeliveryRequest)>(
    future: fetchData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator(
            color: AppColors.blue700,
          )),
        );
      }

      if (snapshot.hasError) {
        return ErrorPage(errorMessage: snapshot.error.toString());
      }

      final (userData, shipmentData, requestData) = snapshot.data!;

      return NegotiationContent(
        user: userData,
        transportItem: shipmentData,
        request: requestData,
      );
    },
  );
}
}



class NegotiationContent extends StatefulWidget {
  final UserData user;
  final DeliveryRequest request;
  final TransportItem transportItem;

  const NegotiationContent({
    super.key,
    required this.user,
    required this.request,
    required this.transportItem,
  });

  @override
  State<NegotiationContent> createState() => _NegotiationContentState();
}

class _NegotiationContentState extends State<NegotiationContent> {
  TextEditingController messageController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool _isProcessing = false;
  String _processingAction = '';
  String  _lastPrice = '';
  
  NegotiationTurn  currentTurn = NegotiationTurn.sender;
  NegotiationStatus negotiationStatus = NegotiationStatus.pending;
  int offerCount = 0;
  int maxOfferCount = 5;
  DateTime? lastOfferTime;
  static const int offerTimeoutMinutes = 60; // 1 hour timeout
  bool _hasShownExpiredDialog = false;


  @override
  void initState() {
    super.initState();
    // update the message seen status when the screen is opened
    final chatId =
        getChatId(FirebaseAuth.instance.currentUser!.uid, widget.user.uid);
    Provider.of<NegotiationProvider>(context, listen: false)
        .markMessageAsSeen(chatId)
        .then((_) {
      // print("Message seen status updated");
    }).catchError((error) {
      print("Error updating message seen status: $error");
    });
    
    if (widget.request.senderId == widget.user.uid) {
      currentTurn = NegotiationTurn.receiver;
    } else {
      currentTurn = NegotiationTurn.sender;
    }
    _lastPrice = widget.request.price.toString();
  }

  int getOfferCount(List<NegotiationModel> messages) {
    if (messages.isEmpty) {
      return 0;
    }
      return messages.length;
  }
  
  String getLastPrice(List<NegotiationModel> messages) {
    if (messages.isEmpty) {
      return widget.request.price.toString();
    }
    return messages.first.price;
  }

    bool  isMyTurn(List<NegotiationModel> messages) {
      final currenUserId = FirebaseAuth.instance.currentUser!.uid;
      if (messages.isEmpty) {
        print("sender id: ${widget.request.senderId}");
        print("receiver id: ${widget.request.receiverId}");
        print("current user id: $currenUserId");
        if (widget.request.senderId == currenUserId) {
          print("is equal ...");
        };
        return widget.request.receiverId == currenUserId;
      }

      final lastMessage = messages.first;

      print("user id : $currenUserId");
      print("last message sender id : ${lastMessage.senderId}");

      print("last message : ${lastMessage.message} ${lastMessage.price}");

      

      return lastMessage.senderId != currenUserId;
    }

    bool canMakeOffer(List<NegotiationModel> messages) {
      final offerCount = getOfferCount(messages);
      return isMyTurn(messages) 
          && negotiationStatus == NegotiationStatus.pending
          && offerCount < maxOfferCount
          && !isExpired(messages);
    }

     bool isExpired(List<NegotiationModel> messages) {
    if (messages.isEmpty) return false;
    
    // Get the timestamp of the last message
    final lastMessage = messages.first;
    final lastMessageTime = DateTime.parse(lastMessage.timestamp);
    final duration = DateTime.now().difference(lastMessageTime).inMinutes;
    
    return duration > offerTimeoutMinutes;
  }

  void _refuseRequest() async {
     if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
      _processingAction = 'refuse';
    });
    
    try {
        await FirebaseFirestore.instance.runTransaction((transaction) async {

        await Provider.of<DeliveryRequestProvider>(context, listen: false)
          .deleteRequest(widget.request.id!);
        final chatId = getChatId(FirebaseAuth.instance.currentUser!.uid, widget.user.uid);
        await Provider.of<NegotiationProvider>(context, listen: false).deleteNegotiation(chatId); 
      });

      if (mounted) {
        context.pop();
        AppUtils.showDialog(context, "Request refused successfully", AppColors.succes);
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showDialog(context, "Failed to refuse request $e", AppColors.error);
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
          'price': _lastPrice
        });

        // Update the shipment document
        transaction.update(shipmentRef, {
          'status': DeliveryStatus.ongoing,
          'matchedDeliveryId': widget.request.shipmentId,
          'matchedDeliveryUserId': widget.request.senderId,
          'price': _lastPrice
        });

        // Update the request document
        final requestProvider =
            Provider.of<DeliveryRequestProvider>(context, listen: false);
        transaction.update(requestRef, {'status': DeliveryStatus.accepted});
        requestProvider.markRequestAsAccepted(widget.request.id!);
          // await Provider.of<DeliveryRequestProvider>(context, listen: false)
            // .deleteRequest(widget.request.id!);
          final chatId = getChatId(FirebaseAuth.instance.currentUser!.uid, widget.user.uid);
          await Provider.of<NegotiationProvider>(context, listen: false).deleteNegotiation(chatId);

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
          context.pop();
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
    // if (!canMakeOffer(messages)) return;
    if (messageController.text.isEmpty) return;

    // print("user id ${widget.user.uid}");
    NegotiationModel message = NegotiationModel(
        receiverId: widget.user.uid,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        timestamp: DateTime.now().toString(),
        message: messageController.text,
        price: priceController.text,
        shipmentId: widget.request.shipmentId,
        requestId: widget.request.id,
        turnCount: offerCount + 1,
        lastUpdate: DateTime.now().toString(),
      );
    try {
      await Provider.of<NegotiationProvider>(context, listen: false)
          .addMessage(message);
      if (widget.request.status != "negotiation") {
        Provider.of<DeliveryRequestProvider>(context, listen: false)
          .updateRequestStatus(widget.request.id!, "negotiation");
      }
      setState(() {
        _lastPrice = message.price;
        offerCount++;
        currentTurn = currentTurn == NegotiationTurn.sender ? NegotiationTurn.receiver : NegotiationTurn.sender;
        lastOfferTime = DateTime.now();
      });
      messageController.clear();
      priceController.clear();
    } catch (e) {
      // print("Error sending message: $e");
      if (mounted) {
        AppUtils.showDialog(context, "Failed to send message ${e.toString()}", AppColors.error);
      }
    }
  }

 Future<void> _handleExpiredNegotiation(String? message) async {
    if (_hasShownExpiredDialog) return;
    
    setState(() {
      _hasShownExpiredDialog = true;
      negotiationStatus = NegotiationStatus.expired;
    });

    // Show expired dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.access_time, color: AppColors.warning, size: 24),
                SizedBox(width: 8),
                Text('Negotiation Expired'),
            ],
          ),
          content:  Text(
            message ??
            'This negotiation has expired due to inactivity. The request will be cancelled.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteExpiredNegotiation();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


   Future<void> _deleteExpiredNegotiation() async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Delete the request
        await Provider.of<DeliveryRequestProvider>(context, listen: false)
            .deleteRequest(widget.request.id!);
        
        // Delete the negotiation chat
        final chatId = getChatId(FirebaseAuth.instance.currentUser!.uid, widget.user.uid);
        await Provider.of<NegotiationProvider>(context, listen: false)
            .deleteNegotiation(chatId);
      });

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      print("Error deleting expired negotiation: $e");
      if (mounted) {
        AppUtils.showDialog(context, "Error cleaning up expired negotiation", AppColors.error);
        context.pop();
      }
    }
  }


  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: UserProfileCard(
        header: widget.user.displayName ?? 'Guest',
        onPressed: () => context.push('/profile/statistics?userId=${widget.user.uid}'),
        photoUrl: widget.user.photoUrl ?? AppTheme.defaultProfileImage,
        headerFontSize: 16,
        subHeaderFontSize: 10,
        avatarSize: 36,
        borderColor: AppColors.blue700,
        headerColor: AppColors.appBarText,
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.white,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey[300],
          height: 0.5,
        ),
      ),
    );
  }
  
  
  Widget _buildNegotiationHeader() {
    return StreamBuilder<List<NegotiationModel>>(
      stream: Provider.of<NegotiationProvider>(context, listen: false)
          .getMessages(getChatId(FirebaseAuth.instance.currentUser!.uid, widget.user.uid)),
      builder: (context, snapshot) {
        final messages = snapshot.data ?? [];
        final currentOfferCount = getOfferCount(messages);
        final remainingOffers = maxOfferCount - currentOfferCount;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.blue700.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.handshake, size: 16, color: AppColors.blue700),
                        const SizedBox(width: 4),
                        Text(
                          'Negotiation',
                          style: TextStyle(
                            color: AppColors.blue700,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: remainingOffers <= 2 
                          ? Colors.red.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: remainingOffers <= 2 
                            ? Colors.red.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.swap_horiz,
                          size: 14,
                          color: remainingOffers <= 2 ? Colors.red[700] : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$currentOfferCount/$maxOfferCount',
                          style: TextStyle(
                            color: remainingOffers <= 2 ? Colors.red[700] : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Initial: ${widget.request.price} DH',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (remainingOffers > 0) ...[
                    Text(
                      remainingOffers == 1 
                          ? 'Last offer remaining'
                          : '$remainingOffers offers left',
                      style: TextStyle(
                        color: remainingOffers <= 2 ? Colors.red[600] : Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else ...[
                    Text(
                      'No offers left',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final negotiationProvider = Provider.of<NegotiationProvider>(context);
    final chatId =
        getChatId(FirebaseAuth.instance.currentUser!.uid, widget.user.uid);

    return Scaffold (
        backgroundColor: AppColors.white,
        appBar: _buildAppBar(),
        body: Column(children: [
          _buildNegotiationHeader(),
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
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return  Center(
                            child: Text('Error loading messages ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return  _buildEmptyState();
                      }
                      final messages = snapshot.data ?? [];

                      if (messages.isNotEmpty && isExpired(messages) && !_hasShownExpiredDialog) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _handleExpiredNegotiation(null);
                        });
                      }
                      if (messages.isNotEmpty && getOfferCount(messages) > maxOfferCount ) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _handleExpiredNegotiation("You have reached the maximum number of offers.");
                        });
                      }

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
            StreamBuilder(
              stream: negotiationProvider.getMessages(chatId),
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];
                return _buildFooter(messages);
              }
            )
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

 Widget _buildInputFields(bool isMyNegotiationTurn, bool canOffer) {
    return Column(
      children: [
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
            isRequired: false,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Button(
            hintText: "Send Offer",
            onPressed: () => { _sendMessage()},
            isLoading: false,
            backgroundColor: isMyNegotiationTurn ? AppColors.blue700 : AppColors.lessImportant,
            textColor: Colors.white,
          ),
      ],
    );
  }

  Widget _buildActionButtons(bool isMyTurn, bool canOffer) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: canOffer ? _sendMessage : null,
            icon: Icon(
              Icons.send,
              size: 18,
              color: canOffer ? Colors.white : Colors.grey[400],
            ),
            label: Text(
              "Send Offer",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: canOffer ? Colors.white : Colors.grey[400],
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: canOffer ? AppColors.blue700 : Colors.grey[300],
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        if (isMyTurn && _lastPrice.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildButtons(),
        ],
      ],
    );
  }


 Widget _buildEmptyState() {
    return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.blue700.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  size: 48,
                  color: AppColors.blue700,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Start Negotiating',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Make your first offer to begin the negotiation',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
      ),
    );
  }

  Widget _buildFooter(List<NegotiationModel> messages) {
    // print("building footer");
    final isMyNegotiationTurn = isMyTurn(messages);
    final canOffer = canMakeOffer(messages);
    final offerCount = getOfferCount(messages);
    _lastPrice = getLastPrice(messages);
    final expired = isExpired(messages);
    
    if (expired ) {
      return Container();
    }
    // print("can make an offer $isMyNegotiationTurn, offer count $offerCount, last price $lastPrice, expired $expired");

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
        children: [ 
         _buildStatusIndicator(isMyNegotiationTurn, offerCount),
        const SizedBox(height: 8),
        _buildInputFields(isMyNegotiationTurn, canOffer),
        if (isMyNegotiationTurn) ...[
            const SizedBox(height: 16),
            Text(
              'Responde to: $_lastPrice DH offer',
              style: const TextStyle(
                color: AppColors.headingText,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          const SizedBox(height: 8),
          _buildButtons()
        ],
        ])
      )
    );
  }
  

    Widget _buildStatusIndicator(bool isMyTurn, int offerCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMyTurn 
            ? AppColors.blue700.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMyTurn ? AppColors.blue700.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isMyTurn ? Icons.edit : Icons.hourglass_empty,
            size: 20,
            color: isMyTurn ? AppColors.blue700 : Colors.orange[700],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isMyTurn 
                  ? "Your turn to make an offer"
                  : "Waiting for their response...",
              style: TextStyle(
                color: isMyTurn ? AppColors.blue700 : Colors.orange[700],
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          if (_lastPrice.isNotEmpty) ...[
            Text(
              'Last: $_lastPrice DH',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildcancelButton() {
    return Container(
      // padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _isProcessing ? null : _refuseRequest,
              icon: _isProcessing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.error),
                      ),
                    )
                  : const Icon(Icons.close, size: 18),
              label: Text(_isProcessing ? 'Cancelling...' : 'Cancel Negotiation'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
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
          'Note: ${message.message}',
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
