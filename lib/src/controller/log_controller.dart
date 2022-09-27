import 'package:budget_controller/src/modells/log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget_builder.dart';

class LogController extends GetxController {
  Future<bool> writeLog({
    required String notification,
    required String projectId,
    required String userId,
  }) async {
    CollectionReference logCollection =
        FirebaseFirestore.instance.collection("logs");
    DocumentReference newLog = logCollection.doc();
    String logId = newLog.id;

    try {
      Log temp = Log(
          userId: userId,
          notification: notification,
          date: DateTime.now(),
          projectId: projectId,
          id: logId);
      await newLog.set(temp);
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  List<Log>? loadLogs(
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
