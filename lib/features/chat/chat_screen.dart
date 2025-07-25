import 'package:quickdrop_app/features/chat/request.dart';
import 'package:quickdrop_app/features/chat/chat_conversation_card.dart';
import 'package:quickdrop_app/features/chat/pending_request.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdrop_app/core/widgets/app_header.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/chat/negotiation_card.dart';
import 'package:quickdrop_app/core/providers/negotiation_provider.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  UserData? user;
  int selectedIndex = 0;
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();


    user = Provider.of<UserProvider>(context, listen: false).user;

    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.microtask(() async {
        try {
          final user = FirebaseAuth.instance.currentUser;
          // print("Current user: $user");
          if (user != null) {
            final deliveryProvider =
                Provider.of<DeliveryRequestProvider>(context, listen: false);

            await deliveryProvider.fetchRequests(user.uid);
            // print("Fetched requests: ${deliveryProvider.requests.length}");

            // Extract all senderIds and fetch user data at once
            final userIds = deliveryProvider.requests
                .map((r) => r.senderId)
                .toSet()
                .toList();

            final shipsIds = deliveryProvider.requests
                .map((r) => r.shipmentId)
                .toSet()
                .toList();
            final shipmentProvider =
                Provider.of<ShipmentProvider>(context, listen: false);
            await shipmentProvider.fetchShipmentsByIds(shipsIds);
            await Provider.of<UserProvider>(context, listen: false)
                .fetchUsersData(userIds);
          }
        } catch (e) {
          if (mounted) {
            AppUtils.showDialog(
                context, "Failed to fetch requests: ${e.toString()}", AppColors.error);
          }
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          tabController: _tabController,
          tabs: const [
            "Send",
            "Received",
            "Negotiate",
            "Chats"
          ],
          title: "Offers",
        ),
        body: _isLoading
          ? loadingAnimation() 
          :TabBarView(
            controller: _tabController,
            children: [
              _buildMyRequests(),
              _buildDeliveryRequests(),
              _buildNegotiationRequests(),
              _buildChatConversations(),
            ],
          ),
        );
  }





  Widget _buildNegotiationRequests() {
    final negotiationProvider = Provider.of<NegotiationProvider>(context);

    return Container(
        margin: const EdgeInsets.only(
            left: AppTheme.cardPadding, right: AppTheme.cardPadding),
        child: StreamBuilder(
          stream: negotiationProvider.getConversations(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? loadingAnimation()
              : snapshot.hasError
                  ? const Center(child: Text("Error loading conversations"))
                  : snapshot.hasData && (snapshot.data as List).isNotEmpty
                      ? ListView.builder(
                          itemCount: (snapshot.data as List).length,
                          itemBuilder: (context, index) {
                            // print("data ${snapshot.data as List}");
                            // final user =
                            if (snapshot.data == null) {
                              return  buildEmptyState(
                                     Icons.chat,
                                      "No active negotiations",
                                      "Start negotiating on delivery requests to see them here"
                                  );
                            }
                            final conversation = (snapshot.data as List)[index];
                            if (conversation['userId'] == null || conversation == null 
                              || conversation['shipmentId'] == null 
                              || conversation['requestId'] == null) {
                                // print("conversation:");
                                // print(conversation["requestId"]);
                                // print(conversation["shipmentId"]);
                                // print(conversation["userId"]);
                              return const SizedBox.shrink();
                            }
                            // List<Map<String, dynamic>> user = conversation['user'];
                            // print("user data: ${user}");
                            // print("sender id: ${conversation['participants'][0]}");
                            return Column(children: [
                              if (index == 0)
                                const SizedBox(
                                    height: AppTheme.gapBetweenCards),
                              NegotiationCard (
                                header: conversation['userName'] ?? 'Guest',
                                subHeader: conversation['lastMessage'] ?? 'No messages yet',
                                photoUrl: conversation['photoUrl'],
                                userId: conversation['userId'],
                                isMessageSeen: conversation['lastMessageSeen'],
                                messageSender: conversation['lastMessageSender'],
                                shipmentId: conversation['shipmentId'],
                                requestId: conversation['requestId'],
                              ),
                              const SizedBox(height: AppTheme.gapBetweenCards),
                            ]);
                          },
                        )
                      :  buildEmptyState(
                              Icons.request_page,
                              "No active negotiations",
                              "Start negotiating on delivery requests to see them here"
                          )
        ));
  }



  Widget _buildChatConversations() {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Container(
        margin: const EdgeInsets.only(
            left: AppTheme.cardPadding, right: AppTheme.cardPadding),
        child: StreamBuilder(
          stream: chatProvider.getConversations(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ?  loadingAnimation()
              : snapshot.hasError
                  ? const Center(child: Text("Error loading conversations"))
                  : snapshot.hasData && (snapshot.data as List).isNotEmpty
                      ? ListView.builder(
                          itemCount: (snapshot.data as List).length,
                          itemBuilder: (context, index) {
                            // print("data ${snapshot.data as List}");
                            // final user =
                            if (snapshot.data == null) {
                              return  buildEmptyState(
                                      Icons.chat_bubble,
                                      "No Conversation yet",
                                      "Your chat conversations will appear here once you start messaging"
                                  );
                            }
                            final conversation = (snapshot.data as List)[index];
                            if (conversation['userId'] == null || conversation == null) {
                              return const SizedBox.shrink();
                            }
                            // List<Map<String, dynamic>> user = conversation['user'];
                            // print("user data: ${user}");
                            // print("sender id: ${conversation['participants'][0]}");
                            return Column(children: [
                              if (index == 0)
                                const SizedBox(
                                    height: AppTheme.gapBetweenCards),
                              ChatConversationCard(
                                header: conversation['userName'] ?? 'Guest',
                                subHeader: conversation['lastMessage'] ?? 'No messages yet',
                                photoUrl: conversation['photoUrl'] ?? AppTheme.defaultProfileImage,
                                userId: conversation['userId'],
                                isMessageSeen: conversation['lastMessageSeen'],
                                messageSender:
                                    conversation['lastMessageSender'],
                              ),
                              const SizedBox(height: AppTheme.gapBetweenCards),
                            ]);
                          },
                        )
                      :buildEmptyState(
                          Icons.chat_bubble,
                          "No Conversation yet",
                          "Your chat conversations will appear here once you start messaging"
                      )
        ));
  }

  Widget _buildDeliveryRequests() {
    final requestProvider = Provider.of<DeliveryRequestProvider>(context);
    final requests = requestProvider.requests
        .where((request) =>
            request.status == DeliveryStatus.active &&
            request.receiverId == user!.uid)
        .toList();

    if (requests.isEmpty) {
      return  buildEmptyState(
              Icons.request_page,
               "No Delivery requests",
               "Incoming delivery requests will show up here"
          );
    }
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      return Container(
          margin: const EdgeInsets.only(
              left: AppTheme.cardPadding, right: AppTheme.cardPadding),
          child: ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];

                final userData =
                    Provider.of<UserProvider>(context, listen: false)
                        .getUserById(request.senderId);
                final Shipment? shipment;
                try {
                  shipment =
                      Provider.of<ShipmentProvider>(context, listen: false)
                          .getShipment(request.shipmentId);
                } catch (e) {
                  // print("Error fetching shipment: $e");
                  return const SizedBox.shrink();
                }
                if (userData == null) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    if (index == 0)
                      const SizedBox(height: AppTheme.gapBetweenCards),
                    Request(
                      request: request,
                      user: userData,
                      shipment: shipment,
                    ),
                    const SizedBox(height: AppTheme.gapBetweenCards),
                  ],
                );
              }));
    });
  }

  Widget _buildMyRequests() {
    final requestProvider = Provider.of<DeliveryRequestProvider>(context);
    final requests = requestProvider.requests
        .where((request) =>
            request.status == DeliveryStatus.active &&
            request.senderId == user!.uid)
        .toList();

    if (requests.isEmpty) {
      return buildEmptyState(
          Icons.request_page,
          "No delivery requests sent",
          "Requests you've sent to others will appear here"
      );
    }
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      return Container(
          margin: const EdgeInsets.only(
              left: AppTheme.cardPadding, right: AppTheme.cardPadding),
          child: ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];

                final userData =
                    Provider.of<UserProvider>(context, listen: false)
                        .getUserById(request.receiverId);
                final Shipment? shipment;
                try {
                  shipment =
                      Provider.of<ShipmentProvider>(context, listen: false)
                          .getShipment(request.shipmentId);
                } catch (e) {
                  print("Error fetching shipment: $e");
                  return const SizedBox.shrink();
                }
                if (userData == null) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    if (index == 0)
                      const SizedBox(height: AppTheme.gapBetweenCards),
                    PendingRequest(
                      request: request,
                      user: userData,
                      shipment: shipment,
                    ),
                    const SizedBox(height: AppTheme.gapBetweenCards),
                  ],
                );
              }));
    });
  }
}
