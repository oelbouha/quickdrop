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
    final t = AppLocalizations.of(context)!;
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title:  Text(
            t.notifications,
            style:const  TextStyle(
                color: AppColors.appBarText, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.appBarBackground,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.appBarIcons),
        ),
        body: _isLoading
            ? loadingAnimation()
            : Consumer<NotificationProvider>(
                builder: (context, notifProvider, child) {
                  final notifs = notifProvider.notifications;
                  if (notifs.isEmpty) {
                    return Center(
                        child: buildEmptyState(
                            Icons.notifications, t.no_notification, ""));
                  }
                  return ListView.builder(
                    itemCount: notifs.length,
                    itemBuilder: (context, index) {
                      final notif = notifs[index];

                      return Container(
                        width: double.infinity,
                        color: notif.read ? Theme.of(context).colorScheme.secondary.withOpacity(0.1) 
                          : Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
