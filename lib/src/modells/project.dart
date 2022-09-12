import 'package:budget_controller/src/modells/projection.dart';

import 'cost.dart';
import 'user.dart';

class Project {
  String name;
  List<User> owners;
  List<Cost> allCosts;
  List<Projection> currentProjection;
  List<Projection> finalProjection;

  Project({
    required this.name,
    required this.owners,
    required this.allCosts,
    required this.currentProjection,
    required this.finalProjection,
  });
}
