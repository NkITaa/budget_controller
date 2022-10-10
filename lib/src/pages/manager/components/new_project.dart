import 'package:budget_controller/src/controller/user_controller.dart';
import 'package:budget_controller/src/pages/manager/const_manager.dart';
import 'package:budget_controller/src/widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/format_controller.dart';
import '../../../controller/project_controller.dart';
import '../../../modells/user.dart';

// Screen that is depicted when a new Project is created
class NewProject extends StatefulWidget {
  const NewProject({super.key});

  @override
  State<NewProject> createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  // TextEditing Controller that handles the value of the project name
  TextEditingController projectName = TextEditingController();

  // formKey that validates the input in controller
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // enables access to all methods of the projectController
  ProjectController projectController = Get.find();

  // enables access to all methods of the userController
  UserController userController = Get.find();

  // saves the specific deadline for the project that is going to be created
  DateTime? deadline;

  // says whether date is defined or not
  bool dateExists = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,

      // Handles the Owners Future that is loaded in
      child: FutureBuilder(
          future: userController.getOwners(),
          builder: (BuildContext context, snapshot) {
            // Shows ErrorText when Snapshot has an error
            if (snapshot.hasError) {
              return CustomBuilder.defaultFutureError(
                  error: snapshot.error.toString());
            }

            // Shows ProgressIndicator during loading
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

                /// Input Section consisting of:
                ///
                /// * TextField where ProjectName is written into
                /// * SearchDropDown where Owner id is chosen
                /// * Datepicker where the due date of the Project is chosen
                SizedBox(
                  width: 648,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        CManager.metainfos,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: 200,
                              child: CustomBuilder.defaultTextField(
                                  controller: projectName,
                                  hint: CManager.projectName)),
                          const SizedBox(
                            width: 35,
                          ),
                          SizedBox(
                              width: 200,
                              child: CustomBuilder.customSearchDropDown(
                                project: false,
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
                                        chosenDate: deadline)
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

                /// is responsible for sending the input to the database
                ///
                /// * deadline == null -> sets the bool that checks whether the date is defined to false
                /// * input valid & dateExists -> sends the input to the database and resets all variables
                CustomBuilder.customButton(
                    text: CManager.create,
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
