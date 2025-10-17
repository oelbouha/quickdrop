import 'package:quickdrop_app/features/requests/received_request.dart';
import 'package:quickdrop_app/features/requests/pending_request.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/requests/negotiation_card.dart';
import 'package:quickdrop_app/core/providers/negotiation_provider.dart';


class OfferScreen extends StatefulWidget {
  const OfferScreen({Key? key}) : super(key: key);
  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen>
    with SingleTickerProviderStateMixin {
  UserData? user;
  int selectedIndex = 0;
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    user = Provider.of<UserProvider>(context, listen: false).user;

    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.microtask(() async {
        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final deliveryProvider =
                Provider.of<DeliveryRequestProvider>(context, listen: false);

            await deliveryProvider.fetchRequests(user.uid);

            final userIds = deliveryProvider.requests
                .expand((r) => [r.senderId, r.receiverId])
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
            final t = AppLocalizations.of(context)!;
            AppUtils.showDialog(
                context, t.error_fetch_requests(e.toString()), AppColors.error);
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
    final t = AppLocalizations.of(context)!;
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          tabController: _tabController,
          tabs:  [
            t.send,
            t.received,
            t.negotiate,
          ],
          title: t.requests,
        ),
        body: _isLoading
          ? loadingAnimation()
          :TabBarView(
            controller: _tabController,
            children: [
              _buildMyRequests(),
              _buildDeliveryRequests(),
              _buildNegotiationRequests(),
            ],
          ),
        );
  }





  Widget _buildNegotiationRequests() {
    final t = AppLocalizations.of(context)!;
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
                  ? Center(child: Text(t.error_loading_conversations))
                  : snapshot.hasData && (snapshot.data as List).isNotEmpty
                      ? ListView.builder(
                          itemCount: (snapshot.data as List).length,
                          itemBuilder: (context, index) {
                            if (snapshot.data == null) {
                              return  buildEmptyState(
                                     Icons.chat,
                                      t.no_active_negotiations,
                                      t.no_active_negotiations_subtitle
                                  );
                            }
                            final conversation = (snapshot.data as List)[index];
                            if (conversation['userId'] == null || conversation == null 
                              || conversation['shipmentId'] == null 
                              || conversation['requestId'] == null) {
                              return const SizedBox.shrink();
                            }
                            return Column(children: [
                              if (index == 0)
                                const SizedBox(
                                    height: AppTheme.gapBetweenCards),
                              NegotiationCard (
                                header: conversation['userName'] ?? t.guest,
                                subHeader: conversation['lastMessage'] ?? t.no_messages_yet,
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
                              t.no_active_negotiations,
                              t.no_active_negotiations_subtitle
                          )
        ));
  }


  Widget _buildDeliveryRequests() {
    final t = AppLocalizations.of(context)!;
    final requestProvider = Provider.of<DeliveryRequestProvider>(context);
    final requests = requestProvider.requests
        .where((request) =>
            request.status == DeliveryStatus.active &&
            request.receiverId == user!.uid)
        .toList();

    if (requests.isEmpty) {
      return  buildEmptyState(
              Icons.request_page,
               t.no_delivery_requests,
               t.no_delivery_requests_subtitle
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
    final t = AppLocalizations.of(context)!;
    final requestProvider = Provider.of<DeliveryRequestProvider>(context);
    final requests = requestProvider.requests
        .where((request) =>
            request.status == DeliveryStatus.active &&
            request.senderId == user!.uid)
        .toList();

    if (requests.isEmpty) {
      return buildEmptyState(
          Icons.request_page,
          t.no_delivery_requests_sent,
          t.no_delivery_requests_sent_subtitle
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