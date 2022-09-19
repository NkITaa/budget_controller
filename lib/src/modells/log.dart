import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  String notification;
  String projectId;
  String id;
  DateTime date;

  Log(
      {required this.notification,
      required this.date,
      required this.projectId,
      required this.id});

  Map<String, dynamic> toJson() {
    return {"notification": id, "projectId": projectId, "id": id, "date": date};
  }

  static Log fromJson(DocumentSnapshot<Object?> log) {
    return Log(
        notification: log["notification"],
        date: log["projectId"],
        projectId: log["id"],
        id: log["date"]);
  }
}
