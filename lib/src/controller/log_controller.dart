import 'package:budget_controller/src/modells/log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogController {
  static Future<void> writeLog(
      {required String notification,
      String? projectId,
      required String title,
      bool? toManager}) async {
    CollectionReference logCollection =
        FirebaseFirestore.instance.collection("logs");
    DocumentReference newLog = logCollection.doc();
    String logId = newLog.id;

    Log temp = Log(
        projectId: projectId,
        userId: FirebaseAuth.instance.currentUser!.uid,
        toManager: toManager,
        title: title,
        notification: notification,
        date: DateTime.now(),
        id: logId);
    await newLog.set(temp.toJson());
  }

  static Future<List<Log>?> loadLogs() async {
    List<Log> logs = [];
    await FirebaseFirestore.instance
        .collection('logs')
        .get()
        .then((logsSnapshot) {
      var logDocs = logsSnapshot.docs;
      for (int i = 0; i < logDocs.length; i++) {
        logs.add(Log.fromJson(logDocs[i]));
      }
    });
    return logs;
  }

  static Future<List<Log>?> loadLogsManager({required bool toDecide}) async {
    List<Log> logs = [];
    await FirebaseFirestore.instance
        .collection('logs')
        .get()
        .then((logsSnapshot) {
      var logDocs = logsSnapshot.docs;
      for (int i = 0; i < logDocs.length; i++) {
        if (logDocs[i]["toManager"] == toDecide) {
          logs.add(Log.fromJson(logDocs[i]));
        }
      }
    });
    return logs;
  }

  static Future<void> setRead({required String uid}) async {
    await FirebaseFirestore.instance
        .collection('logs')
        .doc(uid)
        .update({"read": true});
  }

  static Future<void> setUnread({required String uid}) async {
    await FirebaseFirestore.instance
        .collection('logs')
        .doc(uid)
        .update({"read": false});
  }
}
