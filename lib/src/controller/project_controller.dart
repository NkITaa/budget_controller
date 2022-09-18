import 'package:budget_controller/src/modells/cost.dart';
import 'package:budget_controller/src/modells/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modells/budget.dart';
import '../modells/user.dart';
import '../widget_builder.dart';

class ProjectController extends GetxController {
  CollectionReference projectCollection =
      FirebaseFirestore.instance.collection("project");

  Future<SnackBar> createProject(
      {required String name,
      required List<String> ownersId,
      required List<Budget> budgets,
      required BuildContext context}) async {
    CustomBuilder.customProgressIndicator(context: context);
    DocumentReference project = projectCollection.doc();
    String projectId = project.id;
    try {
      Project temp = Project(
          id: projectId,
          name: name,
          ownersId: ownersId,
          costs: null,
          budgets: budgets);
      await project.set(temp);

      return CustomBuilder.customSnackBarObject(
          message: "Projekt angelegt", error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<List<Project>?> loadProjects(
      {required List<String> projectIds, required BuildContext context}) async {
    List<Project> projects = [];
    CustomBuilder.customProgressIndicator(context: context);
    try {
      for (int i = 0; i < projectIds.length; i++) {
        await projectCollection.doc(projectIds[i]).get().then((project) {
          Project temp = Project.fromJson(project);
          projects.add(temp);
        });
      }
      return projects;
    } on FirebaseException catch (e) {
      CustomBuilder.customSnackBar(message: e.toString(), error: true);
      return null;
    }
  }

  Future<SnackBar> addCost(
      {required String projectId,
      required Cost cost,
      required BuildContext context}) async {
    CustomBuilder.customProgressIndicator(context: context);
    try {
      await projectCollection.doc(projectId).update({
        'costs': FieldValue.arrayUnion([cost.toJson()])
      });
      return CustomBuilder.customSnackBarObject(
          message: "Ausgabe hinzugefügt", error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<SnackBar> deleteCost(
      {required String projectId,
      required Cost cost,
      required BuildContext context}) async {
    CustomBuilder.customProgressIndicator(context: context);
    try {
      await projectCollection.doc(projectId).update({
        'costs': FieldValue.arrayRemove([cost.toJson()])
      });
      return CustomBuilder.customSnackBarObject(
          message: "Ausgabe gelöscht", error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<SnackBar> updateCost(
      {required String projectId,
      required Cost costOld,
      required Cost costNew,
      required BuildContext context}) async {
    CustomBuilder.customProgressIndicator(context: context);
    try {
      await projectCollection.doc(projectId).update({
        'costs': FieldValue.arrayRemove([costOld.toJson()])
      });
      await projectCollection.doc(projectId).update({
        'costs': FieldValue.arrayUnion([costNew.toJson()])
      });
      return CustomBuilder.customSnackBarObject(
          message: "Ausgabe bearbeitet", error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<SnackBar> updateBudget(
      {required String projectId,
      required Budget budgetOld,
      required Budget budgetNew,
      required BuildContext context}) async {
    CustomBuilder.customProgressIndicator(context: context);
    try {
      await projectCollection.doc(projectId).update({
        'budgets': FieldValue.arrayRemove([budgetOld.toJson()])
      });
      await projectCollection.doc(projectId).update({
        'budgets': FieldValue.arrayUnion([budgetNew.toJson()])
      });
      return CustomBuilder.customSnackBarObject(
          message: "Budget bearbeitet", error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<SnackBar> addOwner(
      {required String projectId,
      required CustomUser owner,
      required BuildContext context}) async {
    CustomBuilder.customProgressIndicator(context: context);
    try {
      await projectCollection.doc(projectId).update({
        'costs': FieldValue.arrayUnion([owner.toJson()])
      });
      return CustomBuilder.customSnackBarObject(
          message: "Owner hinzugefügt", error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<SnackBar> deleteOwner(
      {required String projectId,
      required CustomUser owner,
      required BuildContext context}) async {
    CustomBuilder.customProgressIndicator(context: context);
    try {
      await projectCollection.doc(projectId).update({
        'costs': FieldValue.arrayRemove([owner.toJson()])
      });
      return CustomBuilder.customSnackBarObject(
          message: "Owner entfernt", error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }
}
