import 'package:budget_controller/src/controller/project_controller.dart';
import 'package:flutter/material.dart';

import '../../../modells/project.dart';
import 'owner_builder.dart';

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

  final Project project;
  final ProjectController projectController;
  final bool enabled;
  final bool sortAscending;
  final int editedRow;
  final int sortColumnIndex;
  final Function state;
  final Function toggle;
  final Function sort;

  @override
  State<ProjectExists> createState() => _ProjectExistsState();
}

class _ProjectExistsState extends State<ProjectExists> {
  late List<double> totalCosts =
      widget.project.costs?.map((cost) => cost.value).toList() ?? [0];

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
        OwnerBuilder.buildComparison(
            totalBudgets: totalBudgets,
            totalCosts: totalCosts,
            redirect: true,
            until: widget.project.deadline,
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
          child: OwnerBuilder.buildTable(
              projectId: widget.project.id,
              projectController: widget.projectController,
              costs: widget.project.costs,
              state: widget.state,
              enabled: widget.enabled,
              editedRow: widget.editedRow,
              toggle: widget.toggle,
              sort: widget.sort,
              sortAscending: widget.sortAscending,
              sortColumnIndex: widget.sortColumnIndex),
        ),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}
