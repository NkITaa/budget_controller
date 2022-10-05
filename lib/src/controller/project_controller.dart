import 'package:budget_controller/src/controller/user_controller.dart';
import 'package:budget_controller/src/modells/cost.dart';
import 'package:budget_controller/src/modells/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const.dart';
import '../modells/budget.dart';
import '../modells/user.dart';
import '../widget_builder.dart';
import 'log_controller.dart';

class ProjectController extends GetxController {
  CollectionReference projectCollection =
      FirebaseFirestore.instance.collection("project");
  CollectionReference logCollection =
      FirebaseFirestore.instance.collection("logs");

  String? owner;
  String? projectId;

  Future<SnackBar> createProject(
      {required String projectName,
      required String ownerId,
      required DateTime deadline,
      required UserController userController}) async {
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
      await userController.setProject(uid: ownerId, projectId: projectId);
      await LogController.writeLog(
        projectId: projectId,
        title: Const.createdProject,
        notification:
            "${Const.createProjectLog[0]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.createProjectLog[1]} $projectName ${Const.createProjectLog[2]} $projectId${Const.createProjectLog[3]} $ownerId",
      );
      return CustomBuilder.customSnackBarObject(
          message: Const.createdProject, error: false);
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

  Future<Project> getProject({required String projectId}) async {
    var projectCollection = FirebaseFirestore.instance.collection('project');
    return projectCollection.doc(projectId).get().then((project) {
      return Project.fromJson(project);
    });
  }

  Future<SnackBar> deleteBudget(
      {required String projectId, required String logId}) async {
    try {
      await projectCollection.doc(projectId).update({'budgets': null});
      await logCollection.doc(logId).update({'toManager': false});
      await LogController.writeLog(
        toManager: false,
        projectId: projectId,
        title: Const.budgetRejected,
        notification:
            "${Const.deleteBudgetLog[0]} $projectId ${Const.deleteBudgetLog[1]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.deleteBudgetLog[2]}",
      );
      return CustomBuilder.customSnackBarObject(
          message: Const.budgetRejected, error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<SnackBar> acceptBudget(
      {required String projectId, required String logId}) async {
    try {
      await projectCollection.doc(projectId).update({'pending': false});
      await logCollection.doc(logId).update({'toManager': false});
      await LogController.writeLog(
        toManager: false,
        projectId: projectId,
        title: Const.budgetApproved,
        notification:
            "${Const.acceptBudgetLog[0]} $projectId ${Const.acceptBudgetLog[1]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.acceptBudgetLog[2]}",
      );
      return CustomBuilder.customSnackBarObject(
          message: Const.budgetApproved, error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<SnackBar> addCost({
    required String projectId,
    required Cost cost,
  }) async {
    try {
      await projectCollection.doc(projectId).update({
        'costs': FieldValue.arrayUnion([cost.toJson()])
      });
      await LogController.writeLog(
        projectId: projectId,
        title: Const.addedCost,
        notification:
            "${Const.addCostLog[0]} ${cost.reason} ${Const.addCostLog[1]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.addCostLog[2]} $projectId ${Const.addCostLog[3]}",
      );
      return CustomBuilder.customSnackBarObject(
          message: Const.addedCost, error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<SnackBar> addBudgets({
    required String projectId,
    required List<Budget> budgets,
  }) async {
    try {
      await projectCollection.doc(projectId).update(
          {"budgets": budgets.map((budget) => budget.toJson()).toList()});
      await LogController.writeLog(
        projectId: projectId,
        toManager: true,
        title: Const.budgetSuggested,
        notification:
            "${Const.addBudgetsLog[0]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.addBudgetsLog[1]} $projectId ${Const.addBudgetsLog[2]}",
      );
      return CustomBuilder.customSnackBarObject(
          message: Const.budgetSuggested, error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<SnackBar> deleteCost({
    required String projectId,
    required Cost cost,
  }) async {
    try {
      await projectCollection.doc(projectId).update({
        'costs': FieldValue.arrayRemove([cost.toJson()])
      });
      await LogController.writeLog(
        projectId: projectId,
        title: Const.costDeleted,
        notification:
            "${Const.deleteCostLog[0]} ${cost.reason} ${Const.deleteCostLog[1]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.deleteCostLog[2]} $projectId ${Const.deleteCostLog[3]}",
      );
      return CustomBuilder.customSnackBarObject(
          message: Const.costDeleted, error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<SnackBar> updateCost({
    required String projectId,
    required Cost costOld,
    required Cost costNew,
  }) async {
    try {
      await projectCollection.doc(projectId).update({
        'costs': FieldValue.arrayRemove([costOld.toJson()])
      });
      await projectCollection.doc(projectId).update({
        'costs': FieldValue.arrayUnion([costNew.toJson()])
      });
      await LogController.writeLog(
        projectId: projectId,
        title: Const.costUpdated,
        notification:
            "${Const.updateCostLog[0]} ${costOld.reason} ${Const.updateCostLog[1]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.updateCostLog[2]} $projectId ${Const.updateCostLog[3]}",
      );
      return CustomBuilder.customSnackBarObject(
          message: Const.costUpdated, error: false);
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
        projectId: projectId,
        title: Const.budgetUpdated,
        notification:
            "${Const.updateBudgetLog[0]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.updateBudgetLog[1]} $projectId ${Const.updateBudgetLog[2]}",
      );
      return CustomBuilder.customSnackBarObject(
          message: Const.budgetUpdated, error: false);
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
        projectId: projectId,
        title: Const.ownerAdded,
        notification:
            "${Const.addOwnerLog[0]} ${owner.id} ${Const.addOwnerLog[1]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.addOwnerLog[2]} $projectId ${Const.addOwnerLog[3]}",
      );
      return CustomBuilder.customSnackBarObject(
          message: Const.ownerAdded, error: false);
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
          projectId: projectId,
          title: Const.ownerDeleted,
          notification:
              "${Const.deleteOwnerLog[0]} ${owner.id} ${Const.deleteOwnerLog[1]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.deleteOwnerLog[2]} $projectId ${Const.deleteOwnerLog[3]}");
      return CustomBuilder.customSnackBarObject(
          message: Const.ownerDeleted, error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }
}
