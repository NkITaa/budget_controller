import 'package:budget_controller/src/modells/cost.dart';
import 'package:budget_controller/src/modells/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../modells/budget.dart';

class ProjectController extends GetxController {
  CollectionReference projectCollection =
      FirebaseFirestore.instance.collection("project");

  Future<void> createProject({required Project project}) async {
    await projectCollection.doc().set(project.toJson());
  }

  Future<List<Project>> loadProjects({required List<String> ids}) async {
    List<Project> projects = [];

    for (int i = 0; i < ids.length; i++) {
      await projectCollection.doc(ids[i]).get().then((project) {
        Project temp = Project.fromJson(project);
        projects.add(temp);
      });
    }
    return projects;
  }

  Future<void> updateBudget(
      {required String id, required List<Budget> budgets}) async {
    projectCollection.doc(id).update(({
          'budgets': FieldValue.delete(),
        }));
  }

  Future<void> addCost({required Cost cost}) async {}

  Future<void> updateCost() async {}

  Future<void> deleteCost() async {}
}
