import 'package:budget_controller/src/modells/cost.dart';
import 'package:budget_controller/src/modells/project.dart';
import 'package:budget_controller/src/pages/owner/components/new_project.dart';
import 'package:budget_controller/src/pages/owner/components/project_exists.dart';
import 'package:budget_controller/src/pages/owner/components/table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/project_controller.dart';
import '../../modells/user.dart';
import '../../widget_builder.dart';
import 'const_owner.dart';

class Owner extends StatefulWidget {
  const Owner({super.key, required this.user});
  final CustomUser user;

  @override
  State<Owner> createState() => _OwnerState();
}

class _OwnerState extends State<Owner> {
  // Gets access to all methods of the ProjectController
  ProjectController projectController = Get.find();

  // Informs whether the editing Button in the Table was pressed
  bool enabled = false;

  // Holds value of row that is edited
  int editedRow = 0;

  // Holds value of Column that is sorted
  int sortColumnIndex = 0;

  // Holds value whether row is sorted ascending or descending
  bool sortAscending = true;

  // Method that is passed on to other part-widgets to change the state in the parent class
  void state() {
    setState(() {});
  }

  /// Method that handles the row selection (is passed on to part-widgets)
  ///
  /// * the editedRow is set here
  /// * the enabled value is toggled
  /// * the state of the parent class is set
  void toggle({required int index}) {
    editedRow = index;
    enabled = !enabled;
    setState(() {});
  }

  /// Method that handles the sort functionality in the table (is passed on to part-widgets)
  ///
  /// * the Table sort method is trigerred
  /// * the Column that is sorted is set
  /// * the sort direction is set
  /// * the state is set
  void sort<T>(
    Comparable<T> Function(Cost d) getField,
    int columnIndex,
    bool ascending,
    TableData source,
  ) {
    source.sortMe<T>(getField, ascending);
    sortColumnIndex = columnIndex;
    sortAscending = ascending;
    setState(() {});
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
        child:

            // Depending if the user has a Project ID a message or a FutureBuilder is depicted
            widget.user.projectId == null
                ? const Center(
                    child: Text(
                      COwner.noProject,
                      style: TextStyle(fontSize: 25),
                    ),
                  )
                : SingleChildScrollView(
                    child:

                        // Handles the Project Future that is loaded in
                        FutureBuilder<Project>(
                            future: projectController.getProject(
                                projectId: widget.user.projectId!),
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<Project> snapshot,
                            ) {
                              // Shows ErrorText when Authentication Stream has an error
                              if (snapshot.hasError) {
                                return CustomBuilder.defaultFutureError(
                                    error: snapshot.error.toString());
                              }

                              // Shows ProgressIndicator during loading
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    width: MediaQuery.of(context).size.width,
                                    child: const CircularProgressIndicator());
                              }

                              Project project = snapshot.data!;

                              /// Determines the Project State
                              ///
                              /// * Project == No Budget -> New Project UI
                              /// * Project == Pending -> Pending UI
                              /// * Else -> Project UI
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
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.black),
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
                                    editedRow: editedRow,
                                    sortColumnIndex: sortColumnIndex,
                                    sort: sort);
                              }
                            }),
                  ),
      ),
    );
  }
}
