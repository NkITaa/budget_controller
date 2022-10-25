import 'package:budget_controller/src/modells/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const.dart';
import '../widget_builder.dart';
import 'log_controller.dart';

// Defines Methods for the User Handling in Firebase
class UserController extends GetxController {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");
  Future<CustomUser?> signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    CustomBuilder.customProgressIndicator(context: context);
    try {
      // Signs user in with email and password
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // When the singIn was successfull the user gets returned
      return await getUser();
    }

    // When an error with Firebase happened, an error SnackBar with the specific error is returned
    on FirebaseException catch (e) {
      CustomBuilder.customSnackBar(message: e.toString(), error: true);
      return null;
    }
  }

  Future<SnackBar> signUp(
      {required String email,
      required String password,
      required String role,
      required String? projectId,
      required BuildContext context}) async {
    try {
      // Creates a User with email & password in firebases authentication api
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Writes User Object to the database
      await createUser(
          user: CustomUser(
              id: FirebaseAuth.instance.currentUser!.uid,
              projectId: projectId,
              role: role));

      // Writes a Log, when the user was created & written in the database
      await LogController.writeLog(
        title: Const.createdUser,
        notification:
            "${Const.signUpLog[0]} $email ${Const.signUpLog[1]} $role ${Const.signUpLog[2]}",
      );

      // Returns a success SnackBar when all steps were successfull
      return CustomBuilder.customSnackBarObject(
          message: Const.createdUser, error: false);
    }

    // When an error with Firebase happened, an error SnackBar with the specific error is returned
    on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  // Resets Users Password
  Future<SnackBar> resetPassword(
      {required String email, required BuildContext context}) async {
    try {
      // Sends reset email to specific user-mail
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Writes a Log, when the password was resetted
      await LogController.writeLog(
        title: Const.sentResetMail,
        notification:
            "${Const.resetPasswordLog[0]} $email ${Const.resetPasswordLog[1]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.resetPasswordLog[2]}",
      );

      // Returns a success SnackBar when all steps were successfull
      return CustomBuilder.customSnackBarObject(
          message: Const.sentResetMail, error: false);
    }

    // When an error with Firebase happened, an error SnackBar with the specific error is returned
    on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  // Changes Users Role
  Future<SnackBar> changeRole(
      {required String uid,
      required String role,
      required BuildContext context}) async {
    try {
      // Updates specific Users Role
      await userCollection.doc(uid).update({'projectsId': role});

      // Writes a Log, when the Role was updates
      await LogController.writeLog(
        title: Const.changedRole,
        notification:
            "${Const.changeRoleLog[0]} $uid ${Const.changeRoleLog[1]} $role ${Const.changeRoleLog[2]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.changeRoleLog[3]}",
      );

      // Returns a success SnackBar when all steps were successfull
      return CustomBuilder.customSnackBarObject(
          message: Const.changedRole, error: false);
    }

    // When an error with Firebase happened, an error SnackBar with the specific error is returned
    on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  // Creates User by writing his record to the dataBase
  Future<void> createUser({required CustomUser user}) async {
    await userCollection.doc(user.id).set(user.toJson());
  }

  // Gets Owners without projects
  Future<List<CustomUser>> getOwners() async {
    // List that records specific owners
    List<CustomUser> owners = [];

    // Gets all Users
    var users = await userCollection.get().then((value) {
      return value.docs;
    });

    if (users.isNotEmpty) {
      // Iterates through all Users
      for (int i = 0; i < users.length; i++) {
        var owner = users[i];

        // If the User is an Owner and doesnt have an Project, he is added to the list
        if (owner["role"] == Const.userRoles[1] && owner["projectId"] == null) {
          // deserializes specific Owner
          CustomUser temp = CustomUser.fromJson(users[i]);

          // Adds specific Owner to Owner List
          owners.add(temp);
        }
      }
    }

    return owners;
  }

  // Assigned projectId gets written into affected user
  Future<void> setProject(
      {required String uid, required String projectId}) async {
    await userCollection.doc(uid).update({"projectId": projectId});
  }

  // Gets User that is logged in
  Future<CustomUser> getUser() {
    // User id of specific User
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    // Firebase request to specific firebase Document
    return userCollection.doc(uid).get().then((user) {
      // The gotte´n Document gets deserialized
      return CustomUser.fromJson(user);
    });
  }
}
