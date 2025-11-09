import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  void _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notifications_enabled') ?? true;
    setState(() {
      _notificationsEnabled = enabled;
    });
    // make sure the stored notification settings matches firebase messaging
    FirebaseMessaging.instance.setAutoInitEnabled(enabled);
  }

  void _toggleNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    // enable or disable push notifications
    await FirebaseMessaging.instance.setAutoInitEnabled(value);
    if (!value) {
      //  delete the FCM token so the user stops receiving notifications
      try {
        await FirebaseMessaging.instance.deleteToken();
      } catch (e) {
        print('Error deleting FCM token');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notification_settings,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.notification_settings,
                style: const TextStyle(fontSize: 18)),
            Switch(
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
              activeColor: AppColors.succes,
            ),
          ],
        ),
      ),
    );
  }
}
