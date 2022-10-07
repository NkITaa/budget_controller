import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/log_controller.dart';
import '../../../controller/project_controller.dart';
import '../../../modells/log.dart';
import '../../../modells/project.dart';
import '../../../widget_builder.dart';
import '../const_manager.dart';
import '../manager_builder.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  ProjectController projectController = Get.find();
  List<bool?> tileState = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        FutureBuilder(
          future: LogController.loadLogsManager(toDecide: true),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return CustomBuilder.defaultFutureError(
                  error: snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  child: const CircularProgressIndicator());
            }

            final logs = snapshot.requireData;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: logs!.length,
              itemBuilder: (context, index) {
                Log log = logs[index];
                tileState.add(log.toManager);

                if (tileState[index] == true) {
                  return ExpansionTile(
                    title: Text(
                      log.title,
                      style: const TextStyle(color: Colors.black),
                    ),
                    children: [
                      log.toManager == true
                          ? FutureBuilder<Project>(
                              future: projectController.getProject(
                                  projectId: log.projectId!),
                              builder: (
                                BuildContext context,
                                AsyncSnapshot<Project> snapshot,
                              ) {
                                if (snapshot.hasError) {
                                  return CustomBuilder.defaultFutureError(
                                      error: snapshot.error.toString());
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      width: MediaQuery.of(context).size.width,
                                      child: const CircularProgressIndicator());
                                }
                                Project project = snapshot.data!;
                                return Column(
                                  children: [
                                    ManagerBuilder.projectExpansionTile(
                                        project: project),
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
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    )
                                  ],
                                );
                              })
                          : Container(),
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
