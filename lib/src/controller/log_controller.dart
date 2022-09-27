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

  static List<Log>? loadLogs(
      {required QuerySnapshot<Object?> data, required BuildContext context}) {
    List<Log> logs = [];

    try {
      for (int i = 0; i < data.docs.length; i++) {
        var log = data.docs[i].data();
        logs.add(Log.fromJson(log));
      }
      return logs;
    } on FirebaseException catch (e) {
      CustomBuilder.customSnackBar(message: e.toString(), error: true);
      return null;
    }
  }
}
