import 'package:budget_controller/src/controller/project_controller.dart';
import 'package:budget_controller/src/pages/owner/components/owner_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../const.dart';
import '../../../controller/format_controller.dart';
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
  late List<double> totalCosts = widget.totalCosts;
  bool enabled = false;
  DateTime? costDeadline;
  double? isPrice;

  late List<TextEditingController> costsController = [
    TextEditingController(
        text:
            "${FormatController.relevantCosts(costs: widget.costs, category: Const.costTypes[0], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}€"),
    TextEditingController(
        text:
            "${FormatController.relevantCosts(costs: widget.costs, category: Const.costTypes[1], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}€"),
    TextEditingController(
        text:
            "${FormatController.relevantCosts(costs: widget.costs, category: Const.costTypes[2], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}€"),
    TextEditingController(
        text:
            "${FormatController.relevantCosts(costs: widget.costs, category: Const.costTypes[3], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}€"),
    TextEditingController(
        text:
            "${FormatController.relevantCosts(costs: widget.costs, category: Const.costTypes[4], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}€"),
    TextEditingController(
        text:
            "${FormatController.relevantCosts(costs: widget.costs, category: Const.costTypes[5], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}€")
  ];

  late List<TextEditingController> budgetsController = [
    TextEditingController(text: "${widget.budgets?[0].value ?? 0}€"),
    TextEditingController(text: "${widget.budgets?[1].value ?? 0}€"),
    TextEditingController(text: "${widget.budgets?[2].value ?? 0}€"),
    TextEditingController(text: "${widget.budgets?[3].value ?? 0}€"),
    TextEditingController(text: "${widget.budgets?[4].value ?? 0}€"),
    TextEditingController(text: "${widget.budgets?[5].value ?? 0}€")
  ];

  updateExpanded({required bool state, required int index}) {
    expanded[index] = state;
    setState(() {});
  }

  updateCostsController({required DateTime dateTime}) {
    costDeadline = dateTime;
    for (int i = 0; i < costsController.length; i++) {
      costsController[i].text =
          "${FormatController.relevantCosts(costs: widget.costs, category: Const.costTypes[i], date: dateTime)?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}€";
    }
    isPrice = costsController
        .map((controller) {
          return double.parse(controller.text.replaceAll("€", ""));
        })
        .toList()
        .fold<double>(0, (a, b) => (a) + b);
    setState(() {});
  }

  setIsPrice({required double isPrice}) {
    this.isPrice = isPrice;
  }

  setEnabled({required bool enabled}) {
    this.enabled = enabled;
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
                      costDeadline: costDeadline,
                      updateCostsController: updateCostsController,
                      setIsPrice: setIsPrice,
                      enabled: enabled,
                      setEnabled: setEnabled,
                      expanded: expanded,
                      updateExpanded: updateExpanded,
                      textController: costsController,
                      costs: widget.costs,
                      context: context,
                      budget: false,
                    ),
                    OwnerBuilder.detaillsColumn(
                      until: widget.until,
                      textController: budgetsController,
                      expanded: expanded,
                      updateExpanded: updateExpanded,
                      costs: widget.costs,
                      context: context,
                      budget: true,
                    )
                  ],
                ),
                OwnerBuilder.buildComparison(
                  redirect: false,
                  isPrice: isPrice ?? totalCosts.fold(0, (a, b) => a + b),
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
