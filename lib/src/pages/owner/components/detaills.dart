import 'package:budget_controller/src/pages/owner/components/owner_builder.dart';
import 'package:flutter/material.dart';

import '../../../modells/budget.dart';
import '../../../modells/cost.dart';
import '../../../widget_builder.dart';

class Detaills extends StatelessWidget {
  const Detaills({super.key, required this.costs, required this.budgets});

  final List<Cost>? costs;
  final List<Budget>? budgets;
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OwnerBuilder.detaillsColumn(
                  budgets: budgets,
                  costs: costs,
                  context: context,
                  budget: false,
                ),
                OwnerBuilder.detaillsColumn(
                  budgets: budgets,
                  costs: costs,
                  context: context,
                  budget: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
