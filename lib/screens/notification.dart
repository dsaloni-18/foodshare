// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class Notification {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   Future<void> initNotification() async {
//     AndroidInitializationSettings androidInitializationSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher.png');
//     var initializationSettings =
//         InitializationSettings(android: androidInitializationSettings);
//     await notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveBackgroundNotificationResponse:
//             (NotificationResponse NotificationResponse) async {});
//   }
//   notificationDetails(){
//     return const NotificationDetails(android: AndroidNotificationDetails('channelId', 'channelName',importance: Importance.max));
//   }
// Future showNotification({int id=0,String? title,String? body,String? payload})async{
//   return notificationsPlugin.show(id, title, body,await notificationDetails())
// }

// }
import 'package:flutter/material.dart';

class NotificationScreeen extends StatefulWidget {
  const NotificationScreeen({super.key});

  @override
  State<NotificationScreeen> createState() => _NotificationScreeenState();
}

class _NotificationScreeenState extends State<NotificationScreeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text(
          "Notifications",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}