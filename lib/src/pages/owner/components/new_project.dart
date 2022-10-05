import 'package:budget_controller/src/controller/project_controller.dart';
import 'package:flutter/material.dart';

import '../../../const.dart';
import '../../../modells/budget.dart';
import '../../../modells/project.dart';
import '../../../widget_builder.dart';
import '../../manager/manager_builder.dart';
import '../const_owner.dart';

class NewProject extends StatelessWidget {
  NewProject(
      {super.key,
      required this.project,
      required this.projectController,
      required this.state});

  final Project project;
  final Function state;
  final ProjectController projectController;
  final List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(
            width: 648,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    project.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    COwner.newBudgetTitle,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  COwner.costSections[0],
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
                        controller: controllers[0],
                        hint: COwner.typesHints[0],
                        overlineText: Const.costTypes[0]),
                    ManagerBuilder.costFieldBuilder(
                        controller: controllers[1],
                        hint: COwner.typesHints[1],
                        overlineText: Const.costTypes[1]),
                    ManagerBuilder.costFieldBuilder(
                        controller: controllers[2],
                        hint: COwner.typesHints[2],
                        overlineText: Const.costTypes[2]),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    ManagerBuilder.costFieldBuilder(
                        controller: controllers[3],
                        hint: COwner.typesHints[3],
                        overlineText: Const.costTypes[3]),
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
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  COwner.costSections[1],
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
                        controller: controllers[4],
                        hint: COwner.typesHints[4],
                        overlineText: Const.costTypes[4]),
                    ManagerBuilder.costFieldBuilder(
                        controller: controllers[5],
                        hint: COwner.typesHints[5],
                        overlineText: Const.costTypes[5]),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomBuilder.customButton(
              text: COwner.submit,
              onPressed: ([bool mounted = true]) async {
                if (formKey.currentState!.validate()) {
                  SnackBar snackBar = await projectController.addBudgets(
                    projectId: project.id,
                    budgets: Const.costTypes.asMap().entries.map((entry) {
                      return Budget(
                          type: entry.value,
                          value: double.parse(controllers[entry.key]
                              .text
                              .trim()
                              .replaceFirst("€", "")));
                    }).toList(),
                  );
                  state();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
}
