import 'package:quickdrop_app/features/chat/request.dart';
import 'package:quickdrop_app/features/chat/chat_conversation_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:quickdrop_app/core/utils/imports.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

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
          print('Error fetching requests: $e');
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.barColor,
        // centerTitle: true,
        title: const Text("Chats",
            style: TextStyle(color: AppColors.headingText, fontSize: 16)),
        bottom: CustomTabBar(
          tabs: const ['Chats', 'Requested Deliveries'],
          icons: const ['chat-round.svg', 'request-delivery.svg'],
          selectedIndex: selectedIndex,
          onTabSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
      body: Skeletonizer(
            enabled: _isLoading,
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppTheme.homeScreenPadding,
                right: AppTheme.homeScreenPadding,
                top: AppTheme.homeScreenPadding,
                ),
              child: IndexedStack(
                index: selectedIndex,
                children: [
                  _buildChatConversations(),
                  _buildDeliveryRequests(),
                ],
              )),
    ));
  }

  Widget _buildChatConversations() {
    final chatProvider = Provider.of<ChatProvider>(context);

    return StreamBuilder(
      stream: chatProvider.getConversations(),
      
      builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
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
                          return const Center(child: Text("No conversations yet"));
                        }
                        final conversation = (snapshot.data as List)[index];
                        // List<Map<String, dynamic>> user = conversation['user'];
                        // print("user data: ${user}");
                        // print("sender id: ${conversation['participants'][0]}");
                        return ChatConversationCard(
                          header: conversation['userName'],
                          subHeader: conversation['lastMessage'],
                          photoUrl: conversation['photoUrl'],
                          userId: conversation['userId'],
                        );
                      },
                    )
                  : Center(child: Message(context, "No conversations yet")),
    );
  }

  Widget _buildDeliveryRequests() {
    final requestProvider = Provider.of<DeliveryRequestProvider>(context);
    final requests = requestProvider.requests.where((request) => request.status == DeliveryStatus.active).toList();

    if (requests.isEmpty) { 
      return Center(child: Message(context, "No delivery requests yet"));
    }
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];

            final userData = Provider.of<UserProvider>(context, listen: false)
                .getUserById(request.senderId);
            final  Shipment? shipment;
            try {
              shipment = Provider.of<ShipmentProvider>(context, listen: false)
                .getShipment(request.shipmentId);
            } catch (e) {
              // print("Error fetching shipment: $e");
               return const SizedBox
                  .shrink();
            }
            if (userData == null) {
              return const SizedBox
                  .shrink();
            }
            
            return Column(
              children: [
                Request(request: request, userData: userData.toMap(), shipment: shipment,),
                const SizedBox(height: AppTheme.gapBetweenCards),
              ],
            );
          });
    });
  }
}

// return Column(
//             children: [
//               Request(request: request, userData: userData),
//               const SizedBox(height: AppTheme.gapBetweenCards),
//             ],
//           );
