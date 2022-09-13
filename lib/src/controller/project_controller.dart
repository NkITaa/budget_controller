import 'package:budget_controller/src/modells/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../modells/projection.dart';

class ProjectController extends GetxController {
  Future<void> createProject({required Project project}) async {
    final DocumentReference newProject =
        FirebaseFirestore.instance.collection("project").doc();

    await newProject.set(project.toJson());
  }

  Future<List<Project>> loadProjects({required List<String> ids}) async {
    List<Project> projects = [];
    final CollectionReference projectsCollection =
        FirebaseFirestore.instance.collection("project");

    for (int i = 0; i < ids.length; i++) {
      await projectsCollection.doc(ids[i]).get().then((project) {
        Project temp = Project.fromJson(project);
        projects.add(temp);
      });
    }
    return projects;
  }

  Future<void> updateBudget(
      {required String id, required List<Projection> projections}) async {
    final DocumentReference projectsCollection =
        FirebaseFirestore.instance.collection("project").doc(id);
    projectsCollection.update(({
      'projection': FieldValue.delete(),
    }));
  }

  Future<void> addCost() async {}

  Future<void> updateCost() async {}

  Future<void> deleteCost() async {}
}
