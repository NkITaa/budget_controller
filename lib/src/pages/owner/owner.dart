import 'package:budget_controller/src/modells/budget.dart';
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
import 'const_owner.dart';

class Owner extends StatefulWidget {
  const Owner({super.key, required this.user});
  final CustomUser user;

  @override
  State<Owner> createState() => _OwnerState();
}

class _OwnerState extends State<Owner> {
  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
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
                        final GlobalKey<FormState> formKey =
                            GlobalKey<FormState>();
                        return Form(
                          key: formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 648,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
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
                                            controller: controllers[0],
                                            hint: "IT-Kosten",
                                            overlineText: COwner.arten[0]),
                                        ManagerBuilder.costFieldBuilder(
                                            controller: controllers[1],
                                            hint: "Vertriebs-Kosten",
                                            overlineText: COwner.arten[1]),
                                        ManagerBuilder.costFieldBuilder(
                                            controller: controllers[2],
                                            hint: "Rechts-Kosten",
                                            overlineText: COwner.arten[2]),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        ManagerBuilder.costFieldBuilder(
                                            controller: controllers[3],
                                            hint: "Management-Kosten",
                                            overlineText: COwner.arten[3]),
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
                                            controller: controllers[4],
                                            hint: "Hardware-Kosten",
                                            overlineText: COwner.arten[4]),
                                        ManagerBuilder.costFieldBuilder(
                                            controller: controllers[5],
                                            hint: "Software-Kosten",
                                            overlineText: COwner.arten[5]),
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
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      SnackBar snackBar =
                                          await projectController.addBudgets(
                                        projectId: snapshot.data!.id,
                                        budgets: COwner.arten
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          return Budget(
                                              type: entry.value,
                                              value: double.parse(
                                                  controllers[entry.key]
                                                      .text
                                                      .trim()
                                                      .replaceFirst("€", "")));
                                        }).toList(),
                                      );
                                      setState(() {});
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  isLightMode: true),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        );
                      }
                      if (snapshot.data?.pending == true) {
                        return Column(
                          children: const [
                            SizedBox(
                              height: 100,
                            ),
                            Text(
                              "Dein Budgetentwurf wird geprüft",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.black),
                            ),
                          ],
                        );
                      } else {
                        List<double> totalCosts = snapshot.data?.costs
                                ?.map((cost) => cost.value)
                                .toList() ??
                            [0];
                        List<double> totalBudgets = snapshot.data?.budgets
                                ?.map((budget) => budget.value)
                                .toList() ??
                            [0];

                        return Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              snapshot.data!.name,
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.black),
                            ),
                            OwnerBuilder.buildComparison(
                                totalBudgets: totalBudgets,
                                totalCosts: totalCosts,
                                redirect: true,
                                until: snapshot.data!.deadline,
                                budgets: snapshot.data!.budgets,
                                costs: snapshot.data!.costs,
                                isPrice: totalCosts.fold(0, (a, b) => a + b),
                                shouldPrice:
                                    totalBudgets.fold(0, (a, b) => a + b),
                                context: context),
                            const SizedBox(
                              height: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OwnerBuilder.buildTable(
                                  projectId: snapshot.data!.id,
                                  projectController: projectController,
                                  costs: snapshot.data?.costs,
                                  state: state,
                                  context: context,
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
