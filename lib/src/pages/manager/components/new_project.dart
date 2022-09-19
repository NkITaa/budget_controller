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
  TextEditingController costIt = TextEditingController();
  TextEditingController costLaw = TextEditingController();
  TextEditingController costSales = TextEditingController();
  TextEditingController costManagement = TextEditingController();
  TextEditingController costHardware = TextEditingController();
  TextEditingController costSoftware = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime? dateTime;
  bool dateExists = true;
  String? currentRole;
  List<String> roles = ["Mecika", "Wien", "Qualität"];

  setRole({required String selectedRole}) {
    setState(() {
      currentRole = selectedRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 648,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  "Metainfos",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                  ),
                ),
                Row(
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
                        child: CustomBuilder.customSearchDropDown(
                            items: roles, setItem: setRole)),
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
                          ? FormatController.dateTimeFormatter(
                              dateTime: dateTime!)
                          : "",
                      style: TextStyle(
                          color: dateTime != null ? Colors.black : Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 648,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  "Personalkosten",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ManagerBuilder.costFieldBuilder(
                        controller: costIt,
                        hint: "IT-Kosten",
                        overlineText: "IT"),
                    ManagerBuilder.costFieldBuilder(
                        controller: costSales,
                        hint: "Vertriebs-Kosten",
                        overlineText: "Vertrieb"),
                    ManagerBuilder.costFieldBuilder(
                        controller: costLaw,
                        hint: "Rechts-Kosten",
                        overlineText: "Recht"),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    ManagerBuilder.costFieldBuilder(
                        controller: costManagement,
                        hint: "Management-Kosten",
                        overlineText: "Management"),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 648,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  "Sachkosten",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ManagerBuilder.costFieldBuilder(
                        controller: costHardware,
                        hint: "Hardware-Kosten",
                        overlineText: "Hardware"),
                    ManagerBuilder.costFieldBuilder(
                        controller: costSoftware,
                        hint: "Software-Kosten",
                        overlineText: "Software"),
                  ],
                ),
              ],
            ),
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
