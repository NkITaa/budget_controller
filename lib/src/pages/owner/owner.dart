import 'package:budget_controller/src/modells/cost.dart';
import 'package:budget_controller/src/modells/project.dart';
import 'package:budget_controller/src/pages/owner/components/table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/project_controller.dart';
import '../../modells/user.dart';
import '../../widget_builder.dart';
import '../manager/manager_builder.dart';
import 'components/owner_builder.dart';

class Owner extends StatefulWidget {
  const Owner({super.key, required this.user});
  final CustomUser user;

  @override
  State<Owner> createState() => _OwnerState();
}

class _OwnerState extends State<Owner> {
  TextEditingController costIt = TextEditingController();
  TextEditingController costLaw = TextEditingController();
  TextEditingController costSales = TextEditingController();
  TextEditingController costManagement = TextEditingController();
  TextEditingController costHardware = TextEditingController();
  TextEditingController costSoftware = TextEditingController();
  ProjectController projectController = Get.put(ProjectController());
  bool enabled = false;
  int currentIndex = 0;
  Project? project;

  void toggle({required int index}) {
    currentIndex = index;
    enabled = !enabled;
    setState(() {});
  }

  void state() {
    setState(() {});
  }

  int sortColumnIndex = 0;
  bool sortAscending = true;

  void sort<T>(
    Comparable<T> Function(Cost d) getField,
    int columnIndex,
    bool ascending,
    TableData source,
  ) {
    source.sortMe<T>(getField, ascending);
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 70,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: widget.user.projectId == null
            ? const Center(
                child: Text(
                  "Kein Projekt zugeordnet, kontaktiere das Management",
                  style: TextStyle(fontSize: 25),
                ),
              )
            : SingleChildScrollView(
                child: FutureBuilder<Project>(
                    future: projectController.getProject(
                        projectId: widget.user.projectId!),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<Project> snapshot,
                    ) {
                      if (snapshot.hasError) {
                        snapshot.printError();
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
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data?.budgets == null) {
                        return Column(
                          children: [
                            SizedBox(
                              width: 648,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
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
                                      "Budget Einreichen",
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
                                text: "Einreichen",
                                onPressed: () async {},
                                isLightMode: true),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        );
                      }
                      {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Beispiel Projekt",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black),
                            ),
                            OwnerBuilder.buildComparison(
                                isPrice: 16, shouldPrice: 20, context: context),
                            const SizedBox(
                              height: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OwnerBuilder.buildTable(
                                  state: state,
                                  context: context,
                                  cells: ["cells"],
                                  enabled: enabled,
                                  currentIndex: currentIndex,
                                  toggle: toggle,
                                  sort: sort,
                                  sortAscending: sortAscending,
                                  sortColumnIndex: sortColumnIndex),
                            ),
                            const SizedBox(
                              height: 50,
                            )
                          ],
                        );
                      }
                    }),
              ),
      ),
    );
  }
}
