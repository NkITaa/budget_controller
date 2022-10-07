import 'package:budget_controller/src/controller/project_controller.dart';
import 'package:flutter/material.dart';

import '../../../modells/project.dart';
import 'owner_builder.dart';

class ProjectExists extends StatelessWidget {
  ProjectExists(
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

  final Project project;
  final ProjectController projectController;
  final bool enabled;
  final bool sortAscending;
  final int editedRow;
  final int sortColumnIndex;
  final Function state;
  final Function toggle;
  final Function sort;

  late List<double> totalCosts =
      project.costs?.map((cost) => cost.value).toList() ?? [0];

  late List<double> totalBudgets =
      project.budgets?.map((budget) => budget.value).toList() ?? [0];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          project.name,
          style: const TextStyle(fontSize: 25, color: Colors.black),
        ),
        OwnerBuilder.buildComparison(
            totalBudgets: totalBudgets,
            totalCosts: totalCosts,
            redirect: true,
            until: project.deadline,
            budgets: project.budgets,
            costs: project.costs,
            isPrice: totalCosts.fold(0, (a, b) => a + b),
            shouldPrice: totalBudgets.fold(0, (a, b) => a + b),
            context: context),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: OwnerBuilder.buildTable(
              projectId: project.id,
              projectController: projectController,
              costs: project.costs,
              state: state,
              context: context,
              enabled: enabled,
              editedRow: editedRow,
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
}
