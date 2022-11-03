import 'package:budget_controller/src/controller/project_controller.dart';
import 'package:flutter/material.dart';

import '../../const.dart';
import '../../controller/format_controller.dart';
import '../../modells/project.dart';
import '../../widget_builder.dart';
import '../owner/components/owner_builder.dart';

// Defines Widget Pieces that are used across the Manager UI
class ManagerBuilder {
  // Defines a specific costField by altering the width of the defaultTextField
  static Widget costFieldBuilder(
      {required TextEditingController controller,
      String? hint,
      bool? enabled,
      required String overlineText}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            width: 200,
            child: Text(overlineText,
                style: const TextStyle(
                  color: Colors.black,
                )),
          ),
          SizedBox(
              width: 200,
              child: CustomBuilder.defaultTextField(
                  controller: controller,
                  enabled: enabled,
                  hint: hint,
                  isNum: true)),
        ],
      ),
    );
  }

  /// Depicts the submitted costs of a specific ProjectS
  static Widget projectExpansionTile(
      {required Project project, required bool isBuggetSuggested}) {
    return Column(
      children: [
        SizedBox(
          width: 648,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              // Shows the Projectsname
              Center(
                child: Text(
                  project.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              // Shows all costs of the first Cost Type
              Text(
                Const.costSections[0],
                style: const TextStyle(
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
                      enabled: false,
                      controller: TextEditingController(
                          text:
                              "${isBuggetSuggested ? (project.budgets?[0].value) : (project.costs?[0].value)}${Const.currency}"),
                      overlineText: Const.costTypes[0]),
                  ManagerBuilder.costFieldBuilder(
                      enabled: false,
                      controller: TextEditingController(
                          text:
                              "${isBuggetSuggested ? (project.budgets?[1].value) : (project.costs?[1].value)}${Const.currency}"),
                      overlineText: Const.costTypes[1]),
                  ManagerBuilder.costFieldBuilder(
                      enabled: false,
                      controller: TextEditingController(
                          text:
                              "${isBuggetSuggested ? (project.budgets?[2].value) : (project.costs?[2].value)}${Const.currency}"),
                      overlineText: Const.costTypes[2]),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  ManagerBuilder.costFieldBuilder(
                      enabled: false,
                      controller: TextEditingController(
                          text:
                              "${isBuggetSuggested ? (project.budgets?[3].value) : (project.costs?[3].value)}${Const.currency}"),
                      overlineText: Const.costTypes[3]),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),

        // Shows all suggested costs of the second Cost Type
        SizedBox(
          width: 648,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                Const.costSections[1],
                style: const TextStyle(
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
                      enabled: false,
                      controller: TextEditingController(
                          text:
                              "${isBuggetSuggested ? (project.budgets?[4].value) : (project.costs?[4].value)}${Const.currency}"),
                      overlineText: Const.costTypes[4]),
                  ManagerBuilder.costFieldBuilder(
                      enabled: false,
                      controller: TextEditingController(
                          text:
                              "${isBuggetSuggested ? (project.budgets?[5].value) : (project.costs?[5].value)}${Const.currency}"),
                      overlineText: Const.costTypes[5]),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        )
      ],
    );
  }

  static Widget showPreview(
      {required ProjectController projectController,
      required BuildContext context}) {
    // List of boolean that is altered depending on, wheter the DetailsColumn Expandable Button is expanded
    List<bool> expanded = [false, false, false, false, false, false];

    // Determines whether editing of costs is enabled or disabled
    bool _enabled = false;

    // Holds currently active costDeadline
    DateTime? costDeadline;

    // Holds currently projected isPrice
    double? _isPrice;

    return FutureBuilder(
        future: projectController.getProject(
            projectId: projectController.projectId!),
        builder: (context, snapshot) {
          // Shows ErrorText when Snapshot has an error
          if (snapshot.hasError) {
            return CustomBuilder.defaultFutureError(
                error: snapshot.error.toString());
          }

          // Shows ProgressIndicator during loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: const CircularProgressIndicator());
          }

          final project = snapshot.requireData;

          // Lists all CostTypes with specific value
          late List<TextEditingController> costsController = [
            TextEditingController(
                text:
                    "${FormatController.relevantCosts(costs: project.costs, category: Const.costTypes[0], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}${Const.currency}"),
            TextEditingController(
                text:
                    "${FormatController.relevantCosts(costs: project.costs, category: Const.costTypes[1], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}${Const.currency}"),
            TextEditingController(
                text:
                    "${FormatController.relevantCosts(costs: project.costs, category: Const.costTypes[2], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}${Const.currency}"),
            TextEditingController(
                text:
                    "${FormatController.relevantCosts(costs: project.costs, category: Const.costTypes[3], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}${Const.currency}"),
            TextEditingController(
                text:
                    "${FormatController.relevantCosts(costs: project.costs, category: Const.costTypes[4], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}${Const.currency}"),
            TextEditingController(
                text:
                    "${FormatController.relevantCosts(costs: project.costs, category: Const.costTypes[5], date: DateTime.now())?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}${Const.currency}")
          ];

          // Lists all BudgetTypes with specific value
          late List<TextEditingController> budgetsController = [
            TextEditingController(
                text: "${project.budgets?[0].value ?? 0}${Const.currency}"),
            TextEditingController(
                text: "${project.budgets?[1].value ?? 0}${Const.currency}"),
            TextEditingController(
                text: "${project.budgets?[2].value ?? 0}${Const.currency}"),
            TextEditingController(
                text: "${project.budgets?[3].value ?? 0}${Const.currency}"),
            TextEditingController(
                text: "${project.budgets?[4].value ?? 0}${Const.currency}"),
            TextEditingController(
                text: "${project.budgets?[5].value ?? 0}${Const.currency}")
          ];

          // Enables stateSetting
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            // Updates Expanded State of ExpandableButton
            updateExpanded({required bool state, required int index}) {
              // Reassigns state of specific ExpandableTile when triggered
              expanded[index] = state;

              // State is State to upgrade values graphically
              setState(() {});
            }

            // Updates osts when costDeadline is altered
            updateCostsController({required DateTime dateTime}) {
              // CostDeadline is reassigned
              costDeadline = dateTime;
              // The new value of the specific costs is written in the specific TextEditingController
              for (int i = 0; i < costsController.length; i++) {
                costsController[i].text =
                    "${FormatController.relevantCosts(costs: project.costs, category: Const.costTypes[i], date: dateTime)?.fold<double>(0, (a, b) => a + (b?.value ?? 0)) ?? 0}${Const.currency}";
              }

              // The total isPrice is accordingly updated with sum of new specific costs
              _isPrice = costsController
                  .map((controller) {
                    return double.parse(
                        controller.text.replaceAll(Const.currency, ""));
                  })
                  .toList()
                  .fold<double>(0, (a, b) => (a) + b);

              // State is State to upgrade values graphically
              setState(() {});
            }

            // Value of isPrice is updated, when projections are entered
            setIsPrice({required double isPrice}) {
              // Value is assigned to classes variable
              _isPrice = isPrice;

              // State is State to upgrade values graphically
              setState(() {});
            }

            // Value of enabled is updated, when the editing mode is activated
            setEnabled({required bool enabled}) {
              // Value is assigned to classes variable
              _enabled = enabled;
              // State is State to upgrade values graphically
              setState(() {});
            }

            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
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
                        enabled: _enabled,
                        setEnabled: setEnabled,
                        expanded: expanded,
                        updateExpanded: updateExpanded,
                        textController: costsController,
                        costs: project.costs,
                        context: context,
                        budget: false,
                      ),
                      OwnerBuilder.detailsColumn(
                        until: project.deadline,
                        textController: budgetsController,
                        expanded: expanded,
                        updateExpanded: updateExpanded,
                        costs: project.costs,
                        context: context,
                        budget: true,
                      )
                    ],
                  ),

                  // Comparison that shows forecasted values in Comparison with Budget
                  OwnerBuilder.buildComparison(
                    redirect: false,
                    isPrice: _isPrice ??
                        (project.costs?.map((cost) => cost.value).toList() ??
                                [0])
                            .fold(0, (a, b) => a + b),
                    shouldPrice: (project.budgets
                                ?.map((budget) => budget.value)
                                .toList() ??
                            [0])
                        .fold(0, (a, b) => a + b),
                  )
                ],
              ),
            );
          });
        });
  }
}
