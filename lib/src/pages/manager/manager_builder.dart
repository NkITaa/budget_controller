import 'package:flutter/material.dart';

import '../../widget_builder.dart';

class ManagerBuilder {
  static Widget costFieldBuilder(
      {required TextEditingController controller,
      String? hint,
      bool? enabled,
      required String overlineText}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            width: 200,
            child: Text(overlineText,
                style: const TextStyle(
                  color: Colors.black,
                )),
          ),
          SizedBox(
              width: 200,
              child: CustomBuilder.popUpTextField(
                  controller: controller,
                  enabled: enabled,
                  hint: hint,
                  isSumme: true)),
        ],
      ),
    );
  }
}
