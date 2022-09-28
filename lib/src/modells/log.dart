import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  String notification;
  String title;
  String id;
  DateTime date;
  bool read;

  Log(
      {required this.notification,
      required this.title,
      required this.date,
      required this.id,
      this.read = false});

  Map<String, dynamic> toJson() {
    return {
      "notification": notification,
      "title": title,
      "id": id,
      "date": date,
      "read": false
    };
  }

  static Log fromJson(QueryDocumentSnapshot<Map<String, dynamic>> log) {
    return Log(
        notification: log["notification"],
        title: log["title"],
        id: log["id"],
        date: DateTime.parse(log["date"].toDate().toString()),
        read: log["read"]);
  }
}
