import 'package:budget_controller/src/modells/log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogController {
  // new Log is written to database
  static Future<void> writeLog(
      {required String notification,
      String? projectId,
      required String title,
      bool? toManager}) async {
    CollectionReference logCollection =
        FirebaseFirestore.instance.collection("logs");
    DocumentReference newLog = logCollection.doc();
    String logId = newLog.id;

    // a temporary Log Object is created
    Log temp = Log(
        projectId: projectId,
        userId: FirebaseAuth.instance.currentUser!.uid,
        toManager: toManager,
        title: title,
        notification: notification,
        date: DateTime.now(),
        id: logId);

    // the LogObject is serialized to Json and written to the database
    await newLog.set(temp.toJson());
  }

  // all Logs are loaded
  static Future<List<Log>?> loadLogs() async {
    // list that is going to contain all logs
    List<Log> logs = [];

    // gets all log Snapshots
    await FirebaseFirestore.instance
        .collection('logs')
        .get()
        .then((logsSnapshot) {
      var logDocs = logsSnapshot.docs;

      // all the log Snapshots are deserialized and added to the log list
      for (int i = 0; i < logDocs.length; i++) {
        logs.add(Log.fromJson(logDocs[i]));
      }
    });

    // the log List gets returned
    return logs;
  }

  // only gets the logs, that are relevant for the manager
  static Future<List<Log>?> loadLogsManager({required bool toDecide}) async {
    // list that is going to contain manager logs
    List<Log> logs = [];

    // gets all log Snapshots
    await FirebaseFirestore.instance
        .collection('logs')
        .get()
        .then((logsSnapshot) {
      var logDocs = logsSnapshot.docs;

      // all the log Snapshots, that are relevant for the manager are deserialized and added to the log list
      for (int i = 0; i < logDocs.length; i++) {
        if (logDocs[i]["toManager"] == toDecide) {
          logs.add(Log.fromJson(logDocs[i]));
        }
      }
    });

    // the log List gets returned
    return logs;
  }

  // sets a specific log to read
  static Future<void> setRead({required String uid}) async {
    await FirebaseFirestore.instance
        .collection('logs')
        .doc(uid)
        .update({"read": true});
  }

  // sets a specific log to unread
  static Future<void> setUnread({required String uid}) async {
    await FirebaseFirestore.instance
        .collection('logs')
        .doc(uid)
        .update({"read": false});
  }
}
