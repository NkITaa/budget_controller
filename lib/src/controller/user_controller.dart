import 'package:budget_controller/src/modells/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const.dart';
import '../widget_builder.dart';
import 'log_controller.dart';

class UserController extends GetxController {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");
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
      required String? projectId,
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
        title: Const.createdUser,
        notification:
            "${Const.signUpLog[0]} $email ${Const.signUpLog[1]} $role ${Const.signUpLog[2]}",
      );
      return CustomBuilder.customSnackBarObject(
          message: Const.createdUser, error: false);
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
        title: Const.sentResetMail,
        notification:
            "${Const.resetPasswordLog[0]} $email ${Const.resetPasswordLog[1]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.resetPasswordLog[2]}",
      );
      return CustomBuilder.customSnackBarObject(
          message: Const.sentResetMail, error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<SnackBar> changeRole(
      {required String uid,
      required String role,
      required BuildContext context}) async {
    try {
      await userCollection.doc(uid).update({'projectsId': role});
      await LogController.writeLog(
        title: Const.changedRole,
        notification:
            "${Const.changeRoleLog[0]} $uid ${Const.changeRoleLog[1]} $role ${Const.changeRoleLog[2]} ${FirebaseAuth.instance.currentUser!.uid} ${Const.changeRoleLog[3]}",
      );
      return CustomBuilder.customSnackBarObject(
          message: Const.changedRole, error: false);
    } on FirebaseException catch (e) {
      return CustomBuilder.customSnackBarObject(
          message: e.toString(), error: true);
    }
  }

  Future<void> createUser({required CustomUser user}) async {
    await userCollection.doc(user.id).set(user.toJson());
  }

  Future<List<CustomUser>> getOwners() async {
    List<CustomUser> owners = [];
    var users = await userCollection.get().then((value) {
      return value.docs;
    });

    if (users.isNotEmpty) {
      for (int i = 0; i < users.length; i++) {
        var owner = users[i];
        if (owner["role"] == Const.userRoles[1] && owner["projectId"] == null) {
          CustomUser temp = CustomUser.fromJson(users[i]);
          owners.add(temp);
        }
      }
    }

    return owners;
  }

  Future<void> setProject(
      {required String uid, required String projectId}) async {
    await userCollection.doc(uid).update({"projectId": projectId});
  }

  Future<CustomUser> getUser() {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return userCollection.doc(uid).get().then((user) {
      return CustomUser.fromJson(user);
    });
  }
}
