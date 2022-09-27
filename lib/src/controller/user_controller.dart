import 'package:budget_controller/src/modells/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const.dart';
import '../widget_builder.dart';
import 'log_controller.dart';

class UserController extends GetxController {
  Future<CustomUser?> signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    CustomBuilder.customProgressIndicator(context: context);
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return await getUser();
    } on FirebaseException catch (e) {
      CustomBuilder.customSnackBar(message: e.toString(), error: true);
      return null;
    }
  }

  Future<SnackBar> signUp(
      {required String email,
      required String password,
      required String role,
      required String projectId,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await createUser(
          user: CustomUser(
              id: FirebaseAuth.instance.currentUser!.uid,
              projectId: projectId,
              role: role));
      await LogController.writeLog(
          notification: "$role erstellt mit",
          projectId: projectId,
          userId: FirebaseAuth.instance.currentUser!.uid);
      return CustomBuilder.customSnackBarObject(
          message: "User angelegt", error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<SnackBar> resetPassword(
      {required String email, required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      await LogController.writeLog(
          notification: "Resetmail gesendet an $email",
          userId: FirebaseAuth.instance.currentUser!.uid);
      return CustomBuilder.customSnackBarObject(
          message: "Rücksetzungsmail gesendet", error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<SnackBar> changeRole(
      {required String uid,
      required String role,
      required BuildContext context}) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection("user");
    try {
      await userCollection.doc(uid).update({'projectsId': role});
      await LogController.writeLog(
          notification: "Rolle geändert ",
          userId: FirebaseAuth.instance.currentUser!.uid);
      return CustomBuilder.customSnackBarObject(
          message: "Rolle geändert", error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<void> createUser({required CustomUser user}) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection("user");
    await userCollection.doc(user.id).set(user.toJson());
  }

  Future<List<CustomUser>> getOwners() async {
    List<CustomUser> owners = [];
    var users =
        await FirebaseFirestore.instance.collection('user').get().then((value) {
      return value.docs;
    });

    if (users.isNotEmpty) {
      for (int i = 0; i < users.length; i++) {
        if (users[i]["role"] == Const.userRoles[1]) {
          CustomUser temp = CustomUser.fromJson(users[i]);
          owners.add(temp);
        }
      }
    }

    return owners;
  }

  Future<CustomUser> getUser() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection("user");

    return userCollection.doc(uid).get().then((user) {
      return CustomUser.fromJson(user);
    });
  }
}
