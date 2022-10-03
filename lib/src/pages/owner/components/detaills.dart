import 'package:budget_controller/src/controller/project_controller.dart';
import 'package:budget_controller/src/pages/owner/components/owner_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../modells/budget.dart';
import '../../../modells/cost.dart';
import '../../../widget_builder.dart';

class Detaills extends StatefulWidget {
  const Detaills(
      {super.key,
      required this.costs,
      required this.budgets,
      required this.until,
      required this.totalBudgets,
      required this.totalCosts});

  final List<Cost>? costs;
  final DateTime until;
  final List<Budget>? budgets;
  final List<double> totalCosts;
  final List<double> totalBudgets;

  @override
  State<Detaills> createState() => _DetaillsState();
}

class _DetaillsState extends State<Detaills> {
  List<bool> expanded = [false, false, false, false, false, false];
  ProjectController projectController = Get.find();

  updateExpanded({required bool state, required int index}) {
    expanded[index] = state;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBuilder.customAppBar(context: context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 78,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OwnerBuilder.detaillsColumn(
                      expanded: expanded,
                      updateExpanded: updateExpanded,
                      budgets: widget.budgets,
                      costs: widget.costs,
                      context: context,
                      budget: false,
                    ),
                    OwnerBuilder.detaillsColumn(
                      until: widget.until,
                      expanded: expanded,
                      updateExpanded: updateExpanded,
                      budgets: widget.budgets,
                      costs: widget.costs,
                      context: context,
                      budget: true,
                    )
                  ],
                ),
                OwnerBuilder.buildComparison(
                  redirect: false,
                  isPrice: projectController.isPrice ??
                      widget.totalCosts.fold(0, (a, b) => a + b),
                  shouldPrice: widget.totalBudgets.fold(0, (a, b) => a + b),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
