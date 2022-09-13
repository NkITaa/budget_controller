import 'package:budget_controller/src/modells/projection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cost.dart';

class Project {
  String id;
  String name;
  List<String> ownersId;
  List<Cost?> costs;
  List<Projection> projections;

  Project({
    required this.id,
    required this.name,
    required this.ownersId,
    required this.costs,
    required this.projections,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "owners": ownersId,
      "costs":
          costs.isNotEmpty ? costs.map((cost) => cost!.toJson()).toList() : [],
      "projections":
          projections.map((projection) => projection.toJson()).toList(),
    };
  }

  static Project fromJson(DocumentSnapshot<Object?> project) {
    List<dynamic> ownersId = project["ownersId"];
    List<dynamic> costs = project["costs"];
    List<dynamic> projections = project["projections"];
    return Project(
        id: project["id"],
        name: project["name"],
        ownersId: ownersId.cast<String>(),
        costs: project["costs"],
        projections: project["projections"]);
  }
}
