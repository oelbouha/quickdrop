import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/providers/notification_provider.dart';
import 'package:quickdrop_app/features/models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = true;
  // List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = FirebaseAuth.instance.currentUser;
      print("user Id $user.uid");
      await Provider.of<NotificationProvider>(context, listen: false)
          .fetchNotifications(user!.uid);
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
        body: Consumer<NotificationProvider>(
          builder: (context, notifProvider, child) {
            final notifs = notifProvider.notifications;
            if (notifs.isEmpty) {
              return Center(child: Text("No notifications yet"));
            }
            return ListView.builder(
  itemCount: notifs.length,
  itemBuilder: (context, index) {
    final notif = notifs[index];

    return Card(
      color: notif.read ? Colors.grey[200] : Colors.blue[50], 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(notif.message),
        subtitle: Text(
          notif.date.toString(),
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: notif.read
            ? Icon(Icons.check, color: Colors.green)
            : Icon(Icons.circle, color: Colors.red, size: 12),


        onTap: () {
          print("Notification tapped: ${notif.id}");


          // FirebaseFirestore.instance
          //     .collection("notifications")
          //     .doc(notif.id)
          //     .update({"read": true});
        },
      ),
    );
  },
);

          },
        ));
  }
}
