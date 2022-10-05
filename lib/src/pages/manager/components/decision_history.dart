import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../const.dart';
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
  ProjectController projectController = Get.put(ProjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomBuilder.customAppBar(context: context),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 70,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: LogController.loadLogsManager(toDecide: false),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Text(
                            snapshot.error.toString(),
                            style: const TextStyle(
                                fontSize: 30, color: Colors.black),
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
                                        return Column(
                                          children: [
                                            const SizedBox(
                                              height: 100,
                                            ),
                                            Text(
                                              snapshot.error.toString(),
                                              style: const TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        );
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
                                      return Column(
                                        children: [
                                          SizedBox(
                                            width: 648,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.baseline,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    snapshot.data!.name,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 28,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
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
                                                        enabled: false,
                                                        controller:
                                                            TextEditingController(
                                                                text:
                                                                    "${snapshot.data?.budgets?[0].value}€"),
                                                        overlineText:
                                                            Const.costTypes[0]),
                                                    ManagerBuilder.costFieldBuilder(
                                                        enabled: false,
                                                        controller:
                                                            TextEditingController(
                                                                text:
                                                                    "${snapshot.data?.budgets?[1].value}€"),
                                                        overlineText:
                                                            Const.costTypes[1]),
                                                    ManagerBuilder.costFieldBuilder(
                                                        enabled: false,
                                                        controller:
                                                            TextEditingController(
                                                                text:
                                                                    "${snapshot.data?.budgets?[2].value}€"),
                                                        overlineText:
                                                            Const.costTypes[2]),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                Row(
                                                  children: [
                                                    ManagerBuilder.costFieldBuilder(
                                                        enabled: false,
                                                        controller:
                                                            TextEditingController(
                                                                text:
                                                                    "${snapshot.data?.budgets?[3].value}€"),
                                                        overlineText:
                                                            Const.costTypes[3]),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.baseline,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
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
                                                        enabled: false,
                                                        controller:
                                                            TextEditingController(
                                                                text:
                                                                    "${snapshot.data?.budgets?[4].value}€"),
                                                        overlineText:
                                                            Const.costTypes[4]),
                                                    ManagerBuilder.costFieldBuilder(
                                                        enabled: false,
                                                        controller:
                                                            TextEditingController(
                                                                text:
                                                                    "${snapshot.data?.budgets?[5].value}€"),
                                                        overlineText:
                                                            Const.costTypes[5]),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          )
                                        ],
                                      );
                                    })
                                : Container()
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            )));
  }
}
