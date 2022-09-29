import 'package:budget_controller/src/modells/budget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cost.dart';

class Project {
  String id;
  String name;
  String ownerId;
  DateTime deadline;
  List<Cost>? costs;
  List<Budget>? budgets;

  Project({
    required this.deadline,
    required this.id,
    required this.name,
    required this.ownerId,
    required this.costs,
    required this.budgets,
  });

  Map<String, dynamic> toJson() {
    return {
      "deadline": deadline,
      "id": id,
      "name": name,
      "ownerId": ownerId,
      "costs":
          costs != null ? costs!.map((cost) => cost.toJson()).toList() : null,
      "budgets": budgets?.map((budget) => budget.toJson()).toList(),
    };
  }

  static Project fromJson(DocumentSnapshot<Object?> project) {
    List<dynamic>? costsUnserialized = project["costs"];
    List<dynamic>? budgetsUnserialized = project["budgets"];

    List<Cost>? costs = costsUnserialized?.map((cost) {
      return Cost.fromJson(cost);
    }).toList();
    List<Budget>? budgets = budgetsUnserialized?.map((budget) {
      return Budget.fromJson(budget);
    }).toList();

    return Project(
        deadline: DateTime.parse(project["deadline"].toDate().toString()),
        id: project["id"],
        name: project["name"],
        ownerId: project["ownerId"],
        costs: costs,
        budgets: budgets);
  }
}
