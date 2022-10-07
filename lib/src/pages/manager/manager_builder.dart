import 'package:flutter/material.dart';

import '../../const.dart';
import '../../modells/project.dart';
import '../../widget_builder.dart';

class ManagerBuilder {
  // defines a specific costField by altering the width of the defaultTextField
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
  static Widget projectExpansionTile({required Project project}) {
    return Column(
      children: [
        SizedBox(
          width: 648,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              // shows the Projectsname
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

              // shows all costs of the first Cost Type
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
                              "${project.budgets?[0].value}${Const.currency}"),
                      overlineText: Const.costTypes[0]),
                  ManagerBuilder.costFieldBuilder(
                      enabled: false,
                      controller: TextEditingController(
                          text:
                              "${project.budgets?[1].value}${Const.currency}"),
                      overlineText: Const.costTypes[1]),
                  ManagerBuilder.costFieldBuilder(
                      enabled: false,
                      controller: TextEditingController(
                          text:
                              "${project.budgets?[2].value}${Const.currency}"),
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
                              "${project.budgets?[3].value}${Const.currency}"),
                      overlineText: Const.costTypes[3]),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),

        // shows all suggested costs of the second Cost Type
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
                              "${project.budgets?[4].value}${Const.currency}"),
                      overlineText: Const.costTypes[4]),
                  ManagerBuilder.costFieldBuilder(
                      enabled: false,
                      controller: TextEditingController(
                          text:
                              "${project.budgets?[5].value}${Const.currency}"),
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
}
