import 'package:budget_controller/src/widget_builder.dart';
import 'package:flutter/material.dart';

import '../../../controller/format_controller.dart';

class NewProject extends StatefulWidget {
  const NewProject({super.key});

  @override
  State<NewProject> createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  TextEditingController projectName = TextEditingController();
  TextEditingController responsible = TextEditingController();
  DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 200,
                child: CustomBuilder.popUpTextField(
                    controller: projectName, hint: "hint")),
            const SizedBox(
              width: 100,
            ),
            SizedBox(
                width: 200,
                child: CustomBuilder.popUpTextField(
                    controller: projectName, hint: "hint")),
            const SizedBox(
              width: 35,
            ),
            IconButton(
                onPressed: () {
                  CustomBuilder.customDatePicker(
                          context: context, dateTime: dateTime)
                      .then((date) {
                    dateTime = date;
                    setState(() {});
                  });
                },
                icon: const Icon(Icons.calendar_month)),
            Text(
              dateTime != null
                  ? FormatController.dateTimeFormatter(dateTime: dateTime!)
                  : "",
              style: TextStyle(
                  color: dateTime != null ? Colors.black : Colors.grey),
            ),
          ],
        )
      ],
    );
  }
}
