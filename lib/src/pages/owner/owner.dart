import 'package:budget_controller/src/modells/cost.dart';
import 'package:budget_controller/src/modells/project.dart';
import 'package:budget_controller/src/pages/owner/components/new_project.dart';
import 'package:budget_controller/src/pages/owner/components/project_exists.dart';
import 'package:budget_controller/src/pages/owner/components/table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/project_controller.dart';
import '../../modells/user.dart';
import 'const_owner.dart';

class Owner extends StatefulWidget {
  const Owner({super.key, required this.user});
  final CustomUser user;

  @override
  State<Owner> createState() => _OwnerState();
}

class _OwnerState extends State<Owner> {
  ProjectController projectController = Get.put(ProjectController());

  void state() {
    setState(() {});
  }

  bool enabled = false;
  bool sortAscending = true;
  int sortColumnIndex = 0;
  int currentIndex = 0;

  void toggle({required int index}) {
    currentIndex = index;
    enabled = !enabled;
    setState(() {});
  }

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
                  COwner.noProject,
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
                        return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: MediaQuery.of(context).size.width,
                            child: const CircularProgressIndicator());
                      }
                      Project project = snapshot.data!;
                      if (project.budgets == null) {
                        return NewProject(
                            project: project,
                            projectController: projectController,
                            state: state);
                      }
                      if (project.pending == true) {
                        return Column(
                          children: const [
                            SizedBox(
                              height: 100,
                            ),
                            Text(
                              COwner.inAudit,
                              style:
                                  TextStyle(fontSize: 30, color: Colors.black),
                            ),
                          ],
                        );
                      } else {
                        return ProjectExists(
                            project: project,
                            projectController: projectController,
                            state: state,
                            toggle: toggle,
                            enabled: enabled,
                            sortAscending: sortAscending,
                            currentIndex: currentIndex,
                            sortColumnIndex: sortColumnIndex,
                            sort: sort);
                      }
                    }),
              ),
      ),
    );
  }
}
