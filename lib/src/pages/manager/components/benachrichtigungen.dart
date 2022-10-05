import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/log_controller.dart';
import '../../../controller/project_controller.dart';
import '../../../modells/log.dart';
import '../../../modells/project.dart';
import '../../../widget_builder.dart';
import '../../owner/const_owner.dart';
import '../manager_builder.dart';

class Benachrichtigungen extends StatefulWidget {
  const Benachrichtigungen({super.key});

  @override
  State<Benachrichtigungen> createState() => _BenachrichtigungenState();
}

class _BenachrichtigungenState extends State<Benachrichtigungen> {
  ProjectController projectController = Get.put(ProjectController());
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
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      width: MediaQuery.of(context).size.width,
                                      child: const CircularProgressIndicator());
                                }
                                return Column(
                                  children: [
                                    SizedBox(
                                      width: 648,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
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
                                          const Center(
                                            child: Text(
                                              "Budget genehmigen",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
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
                                                  controller: TextEditingController(
                                                      text:
                                                          "${snapshot.data?.budgets?[0].value}€"),
                                                  overlineText:
                                                      COwner.arten[0]),
                                              ManagerBuilder.costFieldBuilder(
                                                  enabled: false,
                                                  controller: TextEditingController(
                                                      text:
                                                          "${snapshot.data?.budgets?[1].value}€"),
                                                  overlineText:
                                                      COwner.arten[1]),
                                              ManagerBuilder.costFieldBuilder(
                                                  enabled: false,
                                                  controller: TextEditingController(
                                                      text:
                                                          "${snapshot.data?.budgets?[2].value}€"),
                                                  overlineText:
                                                      COwner.arten[2]),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                            children: [
                                              ManagerBuilder.costFieldBuilder(
                                                  enabled: false,
                                                  controller: TextEditingController(
                                                      text:
                                                          "${snapshot.data?.budgets?[3].value}€"),
                                                  overlineText:
                                                      COwner.arten[3]),
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
                                                  enabled: false,
                                                  controller: TextEditingController(
                                                      text:
                                                          "${snapshot.data?.budgets?[4].value}€"),
                                                  overlineText:
                                                      COwner.arten[4]),
                                              ManagerBuilder.costFieldBuilder(
                                                  enabled: false,
                                                  controller: TextEditingController(
                                                      text:
                                                          "${snapshot.data?.budgets?[5].value}€"),
                                                  overlineText:
                                                      COwner.arten[5]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomBuilder.customButton(
                                          text: "Annehmen",
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
                                            text: "Ablehnen",
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
                          : Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 28.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nachricht: ${log.notification}",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Ticket Nummer: ${log.id}",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Vom: ${log.date.toString()}",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
