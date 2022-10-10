import 'package:cloud_firestore/cloud_firestore.dart';

// Definition of Log Object
class Log {
  String notification;
  String title;
  String id;
  String userId;
  String? projectId;
  DateTime date;
  bool read;
  bool? toManager;
  bool warning;

  Log(
      {required this.notification,
      required this.title,
      required this.date,
      required this.id,
      required this.userId,
      required this.projectId,
      this.read = false,
      this.warning = false,
      this.toManager});

  // serializes Object to JSON
  Map<String, dynamic> toJson() {
    return {
      "warning": warning,
      "notification": notification,
      "title": title,
      "id": id,
      "userId": userId,
      "projectId": projectId,
      "date": date,
      "read": read,
      "toManager": toManager,
    };
  }

  // serializes Object from JSON
  static Log fromJson(QueryDocumentSnapshot<Map<String, dynamic>> log) {
    return Log(
      warning: log["warning"],
      userId: log["userId"],
      projectId: log["projectId"],
      notification: log["notification"],
      title: log["title"],
      id: log["id"],
      date: DateTime.parse(log["date"].toDate().toString()),
      read: log["read"],
      toManager: log["toManager"],
    );
  }
}
