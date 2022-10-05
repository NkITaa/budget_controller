import 'package:budget_controller/src/controller/user_controller.dart';
import 'package:budget_controller/src/widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/format_controller.dart';
import '../../../controller/project_controller.dart';
import '../../../modells/user.dart';

class NewProject extends StatefulWidget {
  const NewProject({super.key});

  @override
  State<NewProject> createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  TextEditingController projectName = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProjectController projectController = Get.find();

  UserController userController = Get.find();
  DateTime? deadline;
  bool dateExists = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: FutureBuilder(
          future: userController.getOwners(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              snapshot.printError();
              return Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(fontSize: 30, color: Colors.black),
                  ),
                ],
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  child: const CircularProgressIndicator());
            }
            List<CustomUser>? owners = snapshot.requireData;

            return Column(
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
                                  controller: projectName,
                                  hint: "Projektname")),
                          const SizedBox(
                            width: 35,
                          ),
                          SizedBox(
                              width: 200,
                              child: CustomBuilder.customSearchDropDown(
                                items: owners.map((e) => e.id).toList(),
                              )),
                          const SizedBox(
                            width: 35,
                          ),
                          IconButton(
                              onPressed: () {
                                CustomBuilder.customDatePicker(
                                        future: true,
                                        context: context,
                                        dateTime: deadline)
                                    .then((date) {
                                  deadline = date;
                                  dateExists = true;
                                  setState(() {});
                                });
                              },
                              icon: Icon(
                                Icons.calendar_month,
                                color: dateExists ? Colors.black : Colors.red,
                              )),
                          Text(
                            deadline != null
                                ? FormatController.dateTimeFormatter(
                                    dateTime: deadline!)
                                : "",
                            style: TextStyle(
                                color: deadline != null
                                    ? Colors.black
                                    : Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomBuilder.customButton(
                    text: "Anlegen",
                    onPressed: () async {
                      if (deadline == null) {
                        dateExists = false;
                        setState(() {});
                      }
                      if (formKey.currentState!.validate() &&
                          dateExists == true) {
                        SnackBar snackBar =
                            await projectController.createProject(
                          userController: userController,
                          deadline: deadline!,
                          projectName: projectName.text.trim(),
                          ownerId: projectController.owner!,
                        );
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        projectName.text = "";
                        projectController.owner = null;
                        deadline = null;
                        setState(() {});
                      }
                    },
                    isLightMode: true)
              ],
            );
          }),
    );
  }
}
