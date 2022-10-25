import 'package:budget_controller/src/controller/project_controller.dart';
import 'package:flutter/material.dart';

import '../../../modells/project.dart';
import 'owner_builder.dart';

// Screen that is shown when project exists
class ProjectExists extends StatefulWidget {
  const ProjectExists(
      {super.key,
      required this.project,
      required this.projectController,
      required this.state,
      required this.toggle,
      required this.enabled,
      required this.sortAscending,
      required this.editedRow,
      required this.sortColumnIndex,
      required this.sort});

  // Saves current Project
  final Project project;

  // Enables access to projectController methods
  final ProjectController projectController;

  // Informs whether the editing Button in the Table was pressed
  final bool enabled;

  // Holds value of row that is edited
  final int editedRow;

  // Holds value of Column that is sorted
  final int sortColumnIndex;

  // Holds value whether row is sorted ascending or descending
  final bool sortAscending;

  // Changes the state of the parent class
  final Function state;

  // Handles the row selection (defined in parent)
  final Function toggle;

  // Handles the sorting in table (defined in parent)
  final Function sort;

  @override
  State<ProjectExists> createState() => _ProjectExistsState();
}

class _ProjectExistsState extends State<ProjectExists> {
  // Sums up the total costs in project
  late List<double> totalCosts =
      widget.project.costs?.map((cost) => cost.value).toList() ?? [0];

  // Sums up the total budget in project
  late List<double> totalBudgets =
      widget.project.budgets?.map((budget) => budget.value).toList() ?? [0];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          widget.project.name,
          style: const TextStyle(fontSize: 25, color: Colors.black),
        ),

        // Builds the compare tile
        OwnerBuilder.buildComparison(
            projectId: widget.project.id,
            criticalFirebase: widget.project.critical,
            totalBudgets: totalBudgets,
            totalCosts: totalCosts,
            redirect: true,
            until: widget.project.deadline,
            projectController: widget.projectController,
            budgets: widget.project.budgets,
            costs: widget.project.costs,
            isPrice: totalCosts.fold(0, (a, b) => a + b),
            shouldPrice: totalBudgets.fold(0, (a, b) => a + b),
            context: context),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:

              // Builds the tables
              OwnerBuilder.buildTable(
                  projectId: widget.project.id,
                  projectController: widget.projectController,
                  costs: widget.project.costs,
                  state: widget.state,
                  enabled: widget.enabled,
                  editedRow: widget.editedRow,
                  toggle: widget.toggle,
                  sort: widget.sort,
                  sortAscending: widget.sortAscending,
                  sortColumnIndex: widget.sortColumnIndex,
                  context: context),
        ),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}
