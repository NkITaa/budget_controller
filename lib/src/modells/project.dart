import 'package:budget_controller/src/modells/budget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cost.dart';

class Project {
  String id;
  String name;
  List<String> ownerId;
  List<Cost>? costs;
  List<Budget> budgets;

  Project({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.costs,
    required this.budgets,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "ownerId": ownerId,
      "costs":
          costs != null ? costs!.map((cost) => cost.toJson()).toList() : null,
      "budgets": budgets.map((budget) => budget.toJson()).toList(),
    };
  }

  static Project fromJson(DocumentSnapshot<Object?> project) {
    List<dynamic> ownersId = project["ownerId"];
    List<dynamic> costsUnserialized = project["costs"];
    List<dynamic> budgetsUnserialized = project["budgets"];

    List<Cost>? costs = costsUnserialized.isNotEmpty
        ? costsUnserialized.map((cost) => Cost.fromJson(cost)).toList()
        : null;
    List<Budget> budgets = budgetsUnserialized.map((budget) {
      return Budget.fromJson(budget);
    }).toList();

    return Project(
        id: project["id"],
        name: project["name"],
        ownerId: ownersId.cast<String>(),
        costs: costs,
        budgets: budgets);
  }
}
