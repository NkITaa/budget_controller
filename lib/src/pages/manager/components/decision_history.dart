import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/log_controller.dart';
import '../../../controller/project_controller.dart';
import '../../../modells/log.dart';
import '../../../modells/project.dart';
import '../../../widget_builder.dart';
import '../manager_builder.dart';

class DecisionHistory extends StatefulWidget {
  const DecisionHistory({super.key});

  @override
  State<DecisionHistory> createState() => _DecisionHistoryState();
}

class _DecisionHistoryState extends State<DecisionHistory> {
  ProjectController projectController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomBuilder.customAppBar(context: context),
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 70,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder(
                      future: LogController.loadLogsManager(toDecide: false),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasError) {
                          return CustomBuilder.defaultFutureError(
                              error: snapshot.error.toString());
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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

                            return ExpansionTile(
                              title: Text(
                                log.title,
                                style: const TextStyle(color: Colors.black),
                              ),
                              children: [
                                log.toManager == false
                                    ? FutureBuilder<Project>(
                                        future: projectController.getProject(
                                            projectId: log.projectId!),
                                        builder: (
                                          BuildContext context,
                                          AsyncSnapshot<Project> snapshot,
                                        ) {
                                          if (snapshot.hasError) {
                                            return CustomBuilder
                                                .defaultFutureError(
                                                    error: snapshot.error
                                                        .toString());
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.7,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child:
                                                    const CircularProgressIndicator());
                                          }
                                          Project project = snapshot.data!;
                                          return ManagerBuilder
                                              .projectExpansionTile(
                                                  project: project);
                                        })
                                    : Container()
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              )),
        ));
  }
}
