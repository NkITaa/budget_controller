import 'package:budget_controller/src/modells/cost.dart';
import 'package:budget_controller/src/modells/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modells/budget.dart';
import '../modells/user.dart';
import '../widget_builder.dart';
import 'log_controller.dart';

class ProjectController extends GetxController {
  CollectionReference projectCollection =
      FirebaseFirestore.instance.collection("project");
  String? owner;
  String? projectId;

  Future<SnackBar> createProject({
    required String projectName,
    required String ownerId,
    required DateTime deadline,
  }) async {
    DocumentReference newProject = projectCollection.doc();
    String projectId = newProject.id;
    try {
      Project project = Project(
          deadline: deadline,
          id: projectId,
          name: projectName,
          ownerId: ownerId,
          costs: null,
          budgets: null);
      await newProject.set(project.toJson());

      await LogController.writeLog(
        title: "Projekt erstellt",
        notification:
            "Ein neues Projekt wurde von ${FirebaseAuth.instance.currentUser!.uid} mit dem Namen $projectName erstellt. Die ProjektId lautet: $projectId. Die ID des Owners lautet $ownerId",
      );
      return CustomBuilder.customSnackBarObject(
          message: "Projekt angelegt", error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<List<Project>?> loadProjects() async {
    var projects = await FirebaseFirestore.instance
        .collection('project')
        .get()
        .then((value) {
      return value.docs;
    });
    List<Project> ownerlessProjects = [];
    try {
      if (projects.isNotEmpty) {
        for (int i = 0; i < projects.length; i++) {
          var ownerlessProject = projects[i];
          if (ownerlessProject["ownerId"] == null) {
            Project temp = Project.fromJson(ownerlessProject);
            ownerlessProjects.add(temp);
          }
        }
      }
      return ownerlessProjects;
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
      await LogController.writeLog(
        title: "Kosten hinzugefügt",
        notification:
            "Die Kosten für ${cost.reason} wurden von ${FirebaseAuth.instance.currentUser!.uid} in $projectId hinzugefügt",
      );
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
      await LogController.writeLog(
        title: "Kosten gelöscht",
        notification:
            "Die Kosten für ${cost.reason} wurden von ${FirebaseAuth.instance.currentUser!.uid} in $projectId gelöscht",
      );
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
      await LogController.writeLog(
        title: "Kosten bearbeitet",
        notification:
            "Die Kosten für ${costOld.reason} wurden von ${FirebaseAuth.instance.currentUser!.uid} in $projectId geändert",
      );
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
      await LogController.writeLog(
        title: "Budget geändert",
        notification:
            "Das Budget wurde von ${FirebaseAuth.instance.currentUser!.uid} im Projekt $projectId geändert",
      );
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
        'owner': FieldValue.arrayUnion([owner.toJson()])
      });
      await LogController.writeLog(
        title: "Owner hinzugefügt",
        notification:
            "Der Owner ${owner.id} wurde von ${FirebaseAuth.instance.currentUser!.uid} zum Projekt $projectId hinzugefügt",
      );
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
      await LogController.writeLog(
          title: "Owner entfernt",
          notification:
              "Der Owner ${owner.id} wurde von ${FirebaseAuth.instance.currentUser!.uid} vom Projekt $projectId entfernt");
      return CustomBuilder.customSnackBarObject(
          message: "Owner entfernt", error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }
}
