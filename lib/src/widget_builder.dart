import 'package:budget_controller/main.dart';
import 'package:flutter/material.dart';

class CustomBuilder {
  static customProgressIndicator({required BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const Center(
              child: CircularProgressIndicator(),
            ));
  }

  static customSnackBar({required String message, required bool error}) {
    final SnackBar snackBar = SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green);
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
