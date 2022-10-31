import 'package:budget_controller/src/modells/log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Defines methods for the Log Handling in Firebase
class LogController {
  // New Log is written to database
  static Future<void> writeLog(
      {required String notification,
      String? projectId,
      bool? warning,
      required String title,
      bool? toManager}) async {
    CollectionReference logCollection =
        FirebaseFirestore.instance.collection("logs");
    DocumentReference newLog = logCollection.doc();
    String logId = newLog.id;

    // A temporary Log Object is created
    Log temp = Log(
        warning: warning ?? false,
        projectId: projectId,
        userId: FirebaseAuth.instance.currentUser!.uid,
        toManager: toManager,
        title: title,
        notification: notification,
        date: DateTime.now(),
        id: logId);

    // The LogObject is serialized to Json and written to the database
    await newLog.set(temp.toJson());
  }

  // All Logs are loaded
  static Future<List<Log>?> loadLogs() async {
    // list that is going to contain all logs
    List<Log> logs = [];

    // Gets all Log Snapshots
    await FirebaseFirestore.instance
        .collection('logs')
        .get()
        .then((logsSnapshot) {
      var logDocs = logsSnapshot.docs;

      // All the Log Snapshots are deserialized and added to the Log list
      for (int i = 0; i < logDocs.length; i++) {
        logs.add(Log.fromJson(logDocs[i]));
      }
    });

    // The Log List gets returned
    return logs;
  }

  // Only gets the Logs, that are relevant for the manager
  static Future<List<Log>?> loadLogsManager({required bool toDecide}) async {
    // list that is going to contain manager logs
    List<Log> logs = [];

    // Gets all Log Snapshots
    await FirebaseFirestore.instance
        .collection('logs')
        .get()
        .then((logsSnapshot) {
      var logDocs = logsSnapshot.docs;

      // All the Log Snapshots, that are relevant for the manager are deserialized and added to the Log list
      for (int i = 0; i < logDocs.length; i++) {
        if (logDocs[i]["toManager"] == toDecide) {
          logs.add(Log.fromJson(logDocs[i]));
        }
      }
    });

    // The Log List gets returned
    return logs;
  }

  // Sets a specific Log to read
  static Future<void> setRead({required String uid}) async {
    await FirebaseFirestore.instance
        .collection('logs')
        .doc(uid)
        .update({"read": true});
  }

  // Sets a specific Log to unread
  static Future<void> setUnread({required String uid}) async {
    await FirebaseFirestore.instance
        .collection('logs')
        .doc(uid)
        .update({"read": false});
  }
}
