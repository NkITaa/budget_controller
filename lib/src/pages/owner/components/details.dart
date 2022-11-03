import 'package:budget_controller/src/controller/project_controller.dart';
import 'package:budget_controller/src/pages/owner/components/owner_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../const.dart';
import '../../../controller/format_controller.dart';
import '../../../modells/budget.dart';
import '../../../modells/cost.dart';
import '../../../widget_builder.dart';

// Enables Forecasts & Comparison between Costs & Budget
class Details extends StatefulWidget {
  const Details(
      {super.key,
      required this.costs,
      required this.budgets,
      required this.until,
      required this.totalBudgets,
      required this.totalCosts});

  // List of all Costs
  final List<Cost>? costs;

  // List of Budget
  final List<Budget>? budgets;

  // Sum of all Costs
  final List<double> totalCosts;

  // Sum of whole Budget
  final List<double> totalBudgets;

  // Due Date of Budget
  final DateTime until;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  // List of boolean that is altered depending on, wheter the DetailsColumn Expandable Button is expanded
  List<bool> expanded = [false, false, false, false, false, false];

  // Enables Access to all ProjectController Methods
  ProjectController projectController = Get.find();

  // Determines whether editing of costs is enabled or disabled
  bool enabled = false;

  // Holds currently active costDeadline
  DateTime? costDeadline;

  // Holds currently projected isPrice
  double? isPrice;

  // Lists all CostTypes with specific value
  late List<TextEditingController> costsController = [
    TextEditingController(
        text:
            "${FormatController.relevantCosts(costs: widget.costs, category: Const.costTypes[0], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}${Const.currency}"),
    TextEditingController(
        text:
            "${FormatController.relevantCosts(costs: widget.costs, category: Const.costTypes[1], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}${Const.currency}"),
    TextEditingController(
        text:
            "${FormatController.relevantCosts(costs: widget.costs, category: Const.costTypes[2], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}${Const.currency}"),
    TextEditingController(
        text:
            "${FormatController.relevantCosts(costs: widget.costs, category: Const.costTypes[3], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}${Const.currency}"),
    TextEditingController(
        text:
            "${FormatController.relevantCosts(costs: widget.costs, category: Const.costTypes[4], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}${Const.currency}"),
    TextEditingController(
        text:
            "${FormatController.relevantCosts(costs: widget.costs, category: Const.costTypes[5], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}${Const.currency}")
  ];

  // Lists all BudgetTypes with specific value
  late List<TextEditingController> budgetsController = [
    TextEditingController(
        text: "${widget.budgets?[0].value ?? 0}${Const.currency}"),
    TextEditingController(
        text: "${widget.budgets?[1].value ?? 0}${Const.currency}"),
    TextEditingController(
        text: "${widget.budgets?[2].value ?? 0}${Const.currency}"),
    TextEditingController(
        text: "${widget.budgets?[3].value ?? 0}${Const.currency}"),
    TextEditingController(
        text: "${widget.budgets?[4].value ?? 0}${Const.currency}"),
    TextEditingController(
        text: "${widget.budgets?[5].value ?? 0}${Const.currency}")
  ];

  // Updates Expanded State of ExpandableButton
  updateExpanded({required bool state, required int index}) {
    // Reassigns state of specific ExpandableTile when triggered
    expanded[index] = state;

    // State is State to upgrade values graphically
    setState(() {});
  }

  // Updates Costs when costDeadline is altered
  updateCostsController({required DateTime dateTime}) {
    // CostDeadline is reassigned
    costDeadline = dateTime;

    // The new value of the specific costs is written in the specific TextEditingController
    for (int i = 0; i < costsController.length; i++) {
      costsController[i].text =
          "${FormatController.relevantCosts(costs: widget.costs, category: Const.costTypes[i], date: dateTime)?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}${Const.currency}";
    }

    // The total isPrice is accordingly updated with sum of new specific costs
    isPrice = costsController
        .map((controller) {
          return double.parse(controller.text.replaceAll(Const.currency, ""));
        })
        .toList()
        .fold<double>(0, (a, b) => (a) + b);

    // State is State to upgrade values graphically
    setState(() {});
  }

  // Value of isPrice is updated, when projections are entered
  setIsPrice({required double isPrice}) {
    // Value is assigned to classes variable
    this.isPrice = isPrice;

    // State is State to upgrade values graphically
    setState(() {});
  }

  // Value of enabled is updated, when the editing mode is activated
  setEnabled({required bool enabled}) {
    // Value is assigned to classes variable
    this.enabled = enabled;

    // State is State to upgrade values graphically
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
                    /// Builds the Columns
                    ///
                    /// * First: Cost Column
                    /// * Secondly: Budget Column
                    OwnerBuilder.detailsColumn(
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
                    OwnerBuilder.detailsColumn(
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

                // Comparison that shows forecasted values in Comparison with Budget
                OwnerBuilder.buildComparison(
                  redirect: false,
                  isPrice:
                      isPrice ?? widget.totalCosts.fold(0, (a, b) => a + b),
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
