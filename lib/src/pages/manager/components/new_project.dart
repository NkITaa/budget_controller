import 'package:budget_controller/src/const.dart';
import 'package:budget_controller/src/widget_builder.dart';
import 'package:flutter/material.dart';

import '../../../controller/format_controller.dart';
import '../manager_builder.dart';

class NewProject extends StatefulWidget {
  const NewProject({super.key});

  @override
  State<NewProject> createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  TextEditingController projectName = TextEditingController();
  TextEditingController responsible = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime? dateTime;
  bool dateExists = true;
  String selectedRole = Const.userRoles[0];

  stateRole({required String art}) {
    selectedRole = art;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Metainfos",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 200,
                  child: CustomBuilder.popUpTextField(
                      controller: projectName, hint: "Projektname")),
              const SizedBox(
                width: 35,
              ),
              SizedBox(
                  width: 200,
                  child: CustomBuilder.popupDropDown(
                      arten: Const.userRoles,
                      gewaehlteArt: selectedRole,
                      setArt: stateRole)),
              const SizedBox(
                width: 35,
              ),
              IconButton(
                  onPressed: () {
                    CustomBuilder.customDatePicker(
                            context: context, dateTime: dateTime)
                        .then((date) {
                      dateTime = date;
                      dateExists = true;
                      setState(() {});
                    });
                  },
                  icon: Icon(
                    Icons.calendar_month,
                    color: dateExists ? Colors.black : Colors.red,
                  )),
              Text(
                dateTime != null
                    ? FormatController.dateTimeFormatter(dateTime: dateTime!)
                    : "",
                style: TextStyle(
                    color: dateTime != null ? Colors.black : Colors.grey),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Kosten-Projektion",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ManagerBuilder.costFieldBuilder(
                  controller: projectName,
                  hint: "Projektname",
                  overlineText: "Personal"),
              ManagerBuilder.costFieldBuilder(
                  controller: projectName,
                  hint: "Projektname",
                  overlineText: "Bla"),
              ManagerBuilder.costFieldBuilder(
                  controller: projectName,
                  hint: "Projektname",
                  overlineText: "Booo"),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ManagerBuilder.costFieldBuilder(
                  controller: projectName,
                  hint: "Projektname",
                  overlineText: "Booo"),
              ManagerBuilder.costFieldBuilder(
                  controller: projectName,
                  hint: "Projektname",
                  overlineText: "Booo"),
              ManagerBuilder.costFieldBuilder(
                  controller: projectName,
                  hint: "Projektname",
                  overlineText: "Booo"),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ManagerBuilder.costFieldBuilder(
                  controller: projectName,
                  hint: "Projektname",
                  overlineText: "Booo"),
              ManagerBuilder.costFieldBuilder(
                  controller: projectName,
                  hint: "Projektname",
                  overlineText: "Booo"),
              ManagerBuilder.costFieldBuilder(
                  controller: projectName,
                  hint: "Projektname",
                  overlineText: "Booo"),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          CustomBuilder.customButton(
              text: "Anlegen",
              onPressed: () {
                if (dateTime == null) {
                  dateExists = false;
                  setState(() {});
                }
                if (dateTime != null) {
                  dateExists = true;
                  setState(() {});
                }
                if (formKey.currentState!.validate()) {}
              },
              isLightMode: true)
        ],
      ),
    );
  }
}
