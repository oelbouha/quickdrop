import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/providers/notification_provider.dart';
import 'package:quickdrop_app/features/models/notification_model.dart';
import 'package:intl/intl.dart';

String formatDate(String rawDate) {
  DateTime dateTime = DateTime.parse(rawDate);
  String formatted = DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  return formatted;
}


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = FirebaseAuth.instance.currentUser;
      await Provider.of<NotificationProvider>(context, listen: false)
          .fetchNotifications(user!.uid);
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Notifications',
            style: TextStyle(
                color: AppColors.appBarText, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.appBarBackground,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.appBarIcons),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: _isLoading
            ? loadingAnimation()
            : Consumer<NotificationProvider>(
                builder: (context, notifProvider, child) {
                  final notifs = notifProvider.notifications;
                  if (notifs.isEmpty) {
                    return Center(
                        child: buildEmptyState(
                            Icons.notifications, "No Notifications yet", ""));
                  }
                  return ListView.builder(
                    itemCount: notifs.length,
                    itemBuilder: (context, index) {
                      final notif = notifs[index];

                      return Container(
                        width: double.infinity,
                        color: notif.read ? Colors.grey[200] : Colors.blue[50],
                        child: ListTile(
                          title: Text(notif.message),
                          subtitle: Text(
                            formatDate(notif.date.toString()),
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                          trailing: notif.read
                              ? null
                              : const Icon(Icons.circle,
                                  color: Colors.red, size: 12),
                          onTap: () {
                            context.pop();
                            context.go("/requests");
                            notifProvider.markAsRead(notif.id);
                          },
                        ),
                      );
                    },
                  );
                },
              ));
  }
}
