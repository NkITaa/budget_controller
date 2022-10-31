import 'package:budget_controller/src/controller/user_controller.dart';
import 'package:budget_controller/src/modells/cost.dart';
import 'package:budget_controller/src/modells/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const.dart';
import '../modells/budget.dart';
import '../widget_builder.dart';
import 'log_controller.dart';

// Defines Methods for the Project Handling in Firebase
class ProjectController extends GetxController {
  // references  the "project" Collection in Firebase
  CollectionReference projectCollection =
      FirebaseFirestore.instance.collection("project");

  // references  the "logs" Collection in Firebase
  CollectionReference logCollection =
      FirebaseFirestore.instance.collection("logs");

  // OwnerId in DropDown selection is saved here temporarily
  String? owner;

  // ProjectId in DropDown selection is saved here temporarily
  String? projectId;

  // saves temporarily specific project Costs for Owner Project-Table
  List<Cost>? costs;

  // creates a new Project in the database
  Future<SnackBar> createProject(
      {required String projectName,
      required String ownerId,
      required DateTime deadline,
      required UserController userController}) async {
    // creates a new document for a new project
    DocumentReference newProject = projectCollection.doc();

    // gets the id of the new document
    String projectId = newProject.id;

    try {
      // creates a temporary Project Object
      Project project = Project(
          deadline: deadline,
          id: projectId,
          name: projectName,
          ownerId: ownerId,
          costs: null,
          budgets: null);

      // writes & serializes the project object to the database
      await newProject.set(project.toJson());

      // the specific project Id is written in the document of the selected owner
      await userController.setProject(uid: ownerId, projectId: projectId);

      // writes a Log, when the project was created
      await LogController.writeLog(
        projectId: projectId,
        title: Const.createdProject,
        notification:
            "${Const.createProjectLog[0]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.createProjectLog[1]} $projectName ${Const.createProjectLog[2]} $projectId${Const.createProjectLog[3]} $ownerId",
      );

      // returns a success SnackBar when all steps were successfull
      return CustomBuilder.customSnackBarObject(
          message: Const.createdProject, error: false);
    }

    // when an error with Firebase happened, an error SnackBar with the specific error is returned
    on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  // loads ownerless Projects
  Future<List<Project>?> loadProjects() async {
    // creates a list that will save all the ownerless Projects
    List<Project> ownerlessProjects = [];

    try {
      // gets all projects
      var projects = await projectCollection.get().then((value) {
        return value.docs;
      });

      if (projects.isNotEmpty) {
        // iterates through all projects & when no owner is assigned they get added to the List
        for (int i = 0; i < projects.length; i++) {
          var ownerlessProject = projects[i];
          if (ownerlessProject["ownerId"] == null) {
            // Project gets deserialized & added to the List
            Project temp = Project.fromJson(ownerlessProject);
            ownerlessProjects.add(temp);
          }
        }
      }

      // the projects without owners gets returned
      return ownerlessProjects;
    }

    // when an error with Firebase happened, an error SnackBar with the specific error is shown
    on FirebaseException catch (e) {
      CustomBuilder.customSnackBar(message: e.toString(), error: true);
      return null;
    }
  }

  // gets project by projectId
  Future<Project> getProject({required String projectId}) async {
    // gets project by projectId
    return projectCollection.doc(projectId).get().then((project) {
      // deserializes project from Json
      return Project.fromJson(project);
    });
  }

  // Budget gets deleted in the database
  Future<SnackBar> deleteBudget(
      {required String projectId, required String logId}) async {
    try {
      // the value of the budgets attribute is set to null
      await projectCollection.doc(projectId).update({'budgets': null});

      // after that the toManager variable is set to false
      await logCollection.doc(logId).update({'toManager': false});

      // writes a Log, when the budget was deleted
      await LogController.writeLog(
        toManager: false,
        projectId: projectId,
        title: Const.budgetRejected,
        notification:
            "${Const.deleteBudgetLog[0]} $projectId ${Const.deleteBudgetLog[1]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.deleteBudgetLog[2]}",
      );

      // returns a success SnackBar when all steps were successfull
      return CustomBuilder.customSnackBarObject(
          message: Const.budgetRejected, error: false);
    }

    // when an error with Firebase happened, an error SnackBar with the specific error is returned
    on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  // accepts Budget in the database
  Future<SnackBar> acceptBudget(
      {required String projectId, required String logId}) async {
    try {
      // the pending variable is set to false
      await projectCollection.doc(projectId).update({'pending': false});

      // after that the toManager variable is set to false
      await logCollection.doc(logId).update({'toManager': false});

      // writes a Log, when the budget was accepted
      await LogController.writeLog(
        toManager: false,
        projectId: projectId,
        title: Const.budgetApproved,
        notification:
            "${Const.acceptBudgetLog[0]} $projectId ${Const.acceptBudgetLog[1]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.acceptBudgetLog[2]}",
      );

      // returns a success SnackBar when all steps were successfull
      return CustomBuilder.customSnackBarObject(
          message: Const.budgetApproved, error: false);
    }

    // when an error with Firebase happened, an error SnackBar with the specific error is returned
    on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  // adds Cost to the database
  Future<SnackBar> addCost({
    required String projectId,
    required Cost cost,
  }) async {
    try {
      // the value of the specific Cost is added to the existing costs
      await projectCollection.doc(projectId).update({
        // the Cost is serialized and added to the "costs" attribute
        'costs': FieldValue.arrayUnion([cost.toJson()])
      });

      // writes a Log, when the cost was added
      await LogController.writeLog(
        projectId: projectId,
        title: Const.addedCost,
        notification:
            "${Const.addCostLog[0]} ${cost.reason} ${Const.addCostLog[1]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.addCostLog[2]} $projectId ${Const.addCostLog[3]}",
      );

      // returns a success SnackBar when all steps were successfull
      return CustomBuilder.customSnackBarObject(
          message: Const.addedCost, error: false);
    }

    // when an error with Firebase happened, an error SnackBar with the specific error is returned
    on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  // add Budgets to the database
  Future<SnackBar> addBudgets({
    required String projectId,
    required List<Budget> budgets,
  }) async {
    try {
      // all the Budgets get serialized & written as a List to the "budgets" attribute in the database
      await projectCollection.doc(projectId).update(
          {"budgets": budgets.map((budget) => budget.toJson()).toList()});

      // writes a Log, when the budget was added
      await LogController.writeLog(
        projectId: projectId,
        toManager: true,
        title: Const.budgetSuggested,
        notification:
            "${Const.addBudgetsLog[0]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.addBudgetsLog[1]} $projectId ${Const.addBudgetsLog[2]}",
      );

      // returns a success SnackBar when all steps were successfull
      return CustomBuilder.customSnackBarObject(
          message: Const.budgetSuggested, error: false);
    }

    // when an error with Firebase happened, an error SnackBar with the specific error is returned
    on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  // deletes Cost from the database
  Future<SnackBar> deleteCost({
    required String projectId,
    required Cost cost,
  }) async {
    try {
      // the exact cost gets serialied and deleted from the "costs" attribute in the database
      await projectCollection.doc(projectId).update({
        'costs': FieldValue.arrayRemove([cost.toJson()])
      });

      // writes a Log, when the cost was deleted
      await LogController.writeLog(
        projectId: projectId,
        title: Const.costDeleted,
        notification:
            "${Const.deleteCostLog[0]} ${cost.reason} ${Const.deleteCostLog[1]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.deleteCostLog[2]} $projectId ${Const.deleteCostLog[3]}",
      );

      // returns a success SnackBar when all steps were successfull
      return CustomBuilder.customSnackBarObject(
          message: Const.costDeleted, error: false);
    }

    // when an error with Firebase happened, an error SnackBar with the specific error is returned
    on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  // updates specific cost in the database
  Future<SnackBar> updateCost({
    required String projectId,
    required Cost costOld,
    required Cost costNew,
  }) async {
    try {
      // First the old cost gets serialized and deleted from the database
      await projectCollection.doc(projectId).update({
        'costs': FieldValue.arrayRemove([costOld.toJson()])
      });

      // After that the new cost is written to the database
      await projectCollection.doc(projectId).update({
        'costs': FieldValue.arrayUnion([costNew.toJson()])
      });

      // Writes a Log, when the cost was updated
      await LogController.writeLog(
        warning: true,
        projectId: projectId,
        title: Const.costUpdated,
        notification:
            "${Const.updateCostLog[0]} ${costOld.reason} ${Const.updateCostLog[1]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.updateCostLog[2]} $projectId ${Const.updateCostLog[3]}",
      );

      // Returns a success SnackBar when all steps were successfull
      return CustomBuilder.customSnackBarObject(
          message: Const.costUpdated, error: false);
    }

    // When an error with Firebase happened, an error SnackBar with the specific error is returned
    on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  // Informs Manager, that cost situation in Budget is critical
  Future<void> setCritical({required String projectId}) async {
    try {
      // First the value of the critical property gets updated
      await projectCollection.doc(projectId).update({'critical': true});

      // Writes a Log, when the critical tile was set
      await LogController.writeLog(
        warning: true,
        toManager: true,
        projectId: projectId,
        title: Const.criticalBudget,
        notification:
            "${Const.criticalBudgetLog[0]} $projectId ${Const.criticalBudgetLog[1]} ${FirebaseAuth.instance.currentUser!.uid}",
      );
    }

    // When an error with Firebase happened, a Text is displayed
    on FirebaseException catch (e) {
      Text(e.toString());
    }
  }

  // Sets the critical situation to normal, when the critical budget is normal again
  Future<void> setUncritical({required String projectId}) async {
    try {
      // First the value of the critical property gets updated
      await projectCollection.doc(projectId).update({'critical': false});

      // Writes a Log, when the critical tile was set
      await LogController.writeLog(
        projectId: projectId,
        title: Const.uncriticallisedBudget,
        notification:
            "${Const.uncriticallisedBudgetLog[0]} $projectId ${Const.uncriticallisedBudgetLog[1]} ${FirebaseAuth.instance.currentUser!.uid}",
      );
    }

    // When an error with Firebase happened, a Text is displayed
    on FirebaseException catch (e) {
      Text(e.toString());
    }
  }

  Future<SnackBar> setRead(
      {required String projectId, required String logId}) async {
    try {
      // After that the toManager variable is set to false
      await logCollection.doc(logId).update({'toManager': false});

      // Writes a Log, when the transgression was read
      await LogController.writeLog(
        toManager: false,
        projectId: projectId,
        title: Const.readBudgettransgression,
        notification:
            "${Const.readBudgettransgressionLog[0]} $projectId ${Const.readBudgettransgressionLog[1]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.readBudgettransgressionLog[2]}",
      );

      // Returns a success SnackBar when all steps were successfull
      return CustomBuilder.customSnackBarObject(
          message: Const.readBudgettransgression, error: false);
    }

    // When an error with Firebase happened, an error SnackBar with the specific error is returned
    on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  // Gets ProjectIDs
  Future<List<String?>> getProjectIds() async {
    // List that records projectIds
    List<String> projectIds = [];

    // Gets all projects
    var projects = await projectCollection.get().then((value) {
      return value.docs;
    });

    if (projects.isNotEmpty) {
      // Iterates through all Projects
      for (int i = 0; i < projects.length; i++) {
        var project = projects[i];

        // Deserializes projects JSON
        Project temp = Project.fromJson(project);

        // Adds specific projectId to List
        projectIds.add(temp.id);
      }
    }

    return projectIds;
  }
}
