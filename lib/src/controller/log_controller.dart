import 'package:budget_controller/src/modells/log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widget_builder.dart';

class LogController {
  static Future<void> writeLog({
    required String notification,
    String? projectId,
    required String userId,
  }) async {
    CollectionReference logCollection =
        FirebaseFirestore.instance.collection("logs");
    DocumentReference newLog = logCollection.doc();
    String logId = newLog.id;

    Log temp = Log(
        userId: userId,
        notification: notification,
        date: DateTime.now(),
        projectId: projectId,
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
}
