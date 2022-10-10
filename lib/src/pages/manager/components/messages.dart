import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../const.dart';
import '../../../controller/log_controller.dart';
import '../../../controller/project_controller.dart';
import '../../../modells/log.dart';
import '../../../modells/project.dart';
import '../../../widget_builder.dart';
import '../const_manager.dart';
import '../manager_builder.dart';

// Screen that depicts all undecided messages of the Manager
class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  // enables access to all projectController methods
  ProjectController projectController = Get.find();

  // will hold the data, that depicts whether the los is relevant to the manager
  List<bool?> tileState = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),

        // Handles the Manager logs Future that is loaded in
        FutureBuilder(
          future: LogController.loadLogsManager(toDecide: true),
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

            final logs = snapshot.requireData;

            // builds all the relevant Decision that have to be taken in a list
            return ListView.builder(
              shrinkWrap: true,
              itemCount: logs!.length,
              itemBuilder: (context, index) {
                Log log = logs[index];
                tileState.add(log.toManager);

                /// evaluates whether the decision has to be shown
                ///
                /// tileState == true -> shows decision
                /// tileState != true -> doesnt show anything
                if (tileState[index] == true) {
                  return ExpansionTile(
                    title: Text(
                      log.title,
                      style: const TextStyle(color: Colors.black),
                    ),
                    children: [
                      /// Inside the Future Builder is another FutureBuilder
                      ///
                      /// * handles Future of the specific Project in the decision
                      /// * Manager decides whether the evaluated Budget for the Project gets accepted or not
                      FutureBuilder<Project>(
                          future: projectController.getProject(
                              projectId: log.projectId!),
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<Project> snapshot,
                          ) {
                            // Shows ErrorText when Snapshot has an error
                            if (snapshot.hasError) {
                              return CustomBuilder.defaultFutureError(
                                  error: snapshot.error.toString());
                            }

                            // Shows ProgressIndicator during loading
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  width: MediaQuery.of(context).size.width,
                                  child: const CircularProgressIndicator());
                            }
                            Project project = snapshot.data!;
                            return Column(
                              children: [
                                // depicts the detailled Budget of the decision
                                ManagerBuilder.projectExpansionTile(
                                    project: project),

                                /// Decides which Options to show
                                ///
                                /// * log.title == budgetSuggested -> 2 Buttons with accept or reject
                                /// * log.title != budgetSuggested -> 1 Button where log can be set as read
                                log.title == Const.budgetSuggested
                                    ?

                                    /// Builds two buttons
                                    ///
                                    /// * accept -> the budget is accepted and the owner gets access to work on the project
                                    /// * reject -> the budget gets rejected, the owner has to create a new budget
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomBuilder.customButton(
                                            text: CManager.accept,
                                            isDarkMode: true,
                                            onPressed: () async {
                                              SnackBar snackBar =
                                                  await projectController
                                                      .acceptBudget(
                                                          projectId:
                                                              log.projectId!,
                                                          logId: log.id);
                                              if (!mounted) return;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          CustomBuilder.customButton(
                                              text: CManager.reject,
                                              onPressed: () async {
                                                SnackBar snackBar =
                                                    await projectController
                                                        .deleteBudget(
                                                            logId: log.id,
                                                            projectId:
                                                                log.projectId!);
                                                if (!mounted) return;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                setState(() {});
                                              },
                                              isLightMode: true),
                                        ],
                                      )
                                    // Builds one Button, that changes the toManager value when read
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomBuilder.customButton(
                                            text: CManager.read,
                                            isDarkMode: true,
                                            onPressed: () async {
                                              SnackBar snackBar =
                                                  await projectController
                                                      .setRead(
                                                          projectId:
                                                              log.projectId!,
                                                          logId: log.id);
                                              if (!mounted) return;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                const SizedBox(
                                  height: 40,
                                )
                              ],
                            );
                          })
                    ],
                  );
                } else {
                  return Container();
                }
              },
            );
          },
        ),
      ],
    );
  }
}
