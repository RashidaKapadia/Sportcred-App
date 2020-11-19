import 'dart:convert';
import 'package:http/http.dart' as http;

class Notification {
  final int notificationId;
  final String type;
  final String category;
  final String message;
  final int infoId;
  final bool read;

  Notification({
    this.notificationId,
    this.type,
    this.category,
    this.message,
    this.infoId,
    this.read,
  });

  // converts json to Notifications object
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notificationId: json['notificationId'],
      type: json['type'],
      category: json['category'],
      message: json['message'],
      infoId: json['infoId'],
      read: json['read'],
    );
  }
}

Future<List<Notification>> getNotifications(String username) async {
  final http.Response response = await http.post(
    'http://localhost:8080/api/notifications/get',
    headers: {
      'Content-Type': 'text/plain; charset=utf-8',
      'Accept': 'text/plain; charset=utf-8',
      'Access-Control-Allow-Origin': '*',
    },
    body: jsonEncode(<String, String>{'username': username}),
  );

  List<Notification> notifications = [];
  if (response.statusCode == 200) {
    for (Map<String, dynamic> notification
        in jsonDecode(response.body) as List) {
      notifications.add(Notification.fromJson(notification));
    }
  }
  return notifications;
}

Future markReadNotifications(String username, List<int> notifications) async {
  final http.Response response = await http.post(
      'http://localhost:8080/api/notifications/mark-read',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, dynamic>{
        "username": username,
        "notifications": notifications
      }));

  return (response.statusCode == 200);
}

Future deleteNotifications(String username, List<int> notifications) async {
  final http.Response response = await http.post(
      'http://localhost:8080//api/notifications/delete',
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Accept': 'text/plain; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, dynamic>{
        "username": username,
        "notifications": notifications
      }));

  return (response.statusCode == 200);
}
