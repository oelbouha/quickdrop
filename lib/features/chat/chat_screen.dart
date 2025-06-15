import 'package:quickdrop_app/features/chat/request.dart';
import 'package:quickdrop_app/features/chat/chat_conversation_card.dart';

import 'package:quickdrop_app/features/chat/pending_request.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdrop_app/core/widgets/app_header.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

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
  String? userPhotoUrl;

  @override
  void initState() {
    super.initState();
    userPhotoUrl =
        Provider.of<UserProvider>(context, listen: false).user?.photoUrl;
    if (userPhotoUrl == null || userPhotoUrl!.isEmpty) {
      userPhotoUrl = "assets/images/profile.png";
    }

    user = Provider.of<UserProvider>(context, listen: false).user;

    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        try {
          final user = FirebaseAuth.instance.currentUser;
          // print("Current user: $user");
          if (user != null) {
            final deliveryProvider =
                Provider.of<DeliveryRequestProvider>(context, listen: false);

            await deliveryProvider.fetchRequests(user.uid);
            print("Fetched requests: ${deliveryProvider.requests.length}");

            // Extract all senderIds and fetch user data at once
            final userIds = deliveryProvider.requests
                .map((r) => r.senderId)
                .toSet()
                .toList();
            await Provider.of<UserProvider>(context, listen: false)
                .fetchUsersData(userIds);
          }
        } catch (e) {
          // print('Error fetching requests: $e');
          if (mounted)
            AppUtils.showDialog(
                context, "Failed to fetch requests: ${e.toString()}", AppColors.error);
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
          userPhotoUrl: userPhotoUrl!,
          tabController: _tabController,
          tabs: const [
            "Send",
            "Received",
            "Negotiate",
          ],
          title: "Offers",
        ),
        body: Skeletonizer(
          enabled: _isLoading,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMyRequests(),
              _buildDeliveryRequests(),
              _buildDeliveryRequests(),
            ],
          ),
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
              ? const Center(child: CircularProgressIndicator())
              : snapshot.hasError
                  ? const Center(child: Text("Error loading conversations"))
                  : snapshot.hasData && (snapshot.data as List).isNotEmpty
                      ? ListView.builder(
                          itemCount: (snapshot.data as List).length,
                          itemBuilder: (context, index) {
                            print("data ${snapshot.data as List}");
                            // final user =
                            if (snapshot.data == null) {
                              return const Center(
                                  child: Text("No conversations yet"));
                            }
                            final conversation = (snapshot.data as List)[index];
                            // List<Map<String, dynamic>> user = conversation['user'];
                            // print("user data: ${user}");
                            // print("sender id: ${conversation['participants'][0]}");
                            return Column(children: [
                              if (index == 0)
                                const SizedBox(
                                    height: AppTheme.gapBetweenCards),
                              ChatConversationCard(
                                header: conversation['userName'],
                                subHeader: conversation['lastMessage'],
                                photoUrl: conversation['photoUrl'],
                                userId: conversation['userId'],
                                isMessageSeen: conversation['lastMessageSeen'],
                                messageSender:
                                    conversation['lastMessageSender'],
                              ),
                              const SizedBox(height: AppTheme.gapBetweenCards),
                            ]);
                          },
                        )
                      : Center(child: Message(context, "No conversations yet")),
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
      return Center(child: Message(context, "No delivery requests yet"));
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
      return Center(child: Message(context, "No delivery requests yet"));
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
