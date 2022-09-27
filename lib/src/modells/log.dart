import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  String notification;
  String? projectId;
  String userId;
  String id;
  DateTime date;

  Log(
      {required this.notification,
      required this.date,
      required this.projectId,
      required this.userId,
      required this.id});

  Map<String, dynamic> toJson() {
    return {
      "notification": notification,
      "projectId": projectId,
      "id": id,
      "date": date,
      "userId": userId
    };
  }

  static Log fromJson(QueryDocumentSnapshot<Map<String, dynamic>> log) {
    return Log(
        notification: log["notification"],
        projectId: log["projectId"],
        id: log["id"],
        userId: log["userId"],
        date: DateTime.parse(log["date"].toDate().toString()));
  }
}
