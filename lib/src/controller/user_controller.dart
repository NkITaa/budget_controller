import 'package:budget_controller/src/modells/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../Constants/const.dart';
import '../widget_builder.dart';

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
    } on FirebaseAuthException catch (e) {
      CustomBuilder.customSnackBar(message: e.toString(), error: true);
    }
  }

  Future<void> signUp(
      {required String email,
      required String password,
      required String role,
      required List<String?> projectsId,
      required BuildContext context}) async {
    CustomBuilder.customProgressIndicator(context: context);
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await createUser(
          user: CustomUser(
              id: FirebaseAuth.instance.currentUser!.uid,
              projectsId: projectsId,
              role: role));
    } on FirebaseAuthException catch (e) {
      CustomBuilder.customSnackBar(message: e.toString(), error: true);
    }
  }

  Future<void> resetPassword(
      {required String email, required BuildContext context}) async {
    CustomBuilder.customProgressIndicator(context: context);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      CustomBuilder.customSnackBar(
          message: "Rücksetzungsmail gesendet", error: false);
    } on FirebaseAuthException catch (e) {
      CustomBuilder.customSnackBar(message: e.toString(), error: true);
    }
  }

  Future<void> createUser({required CustomUser user}) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection("user");
    try {
      await userCollection.doc(user.id).set(user.toJson());
    } on FirebaseAuthException catch (e) {
      CustomBuilder.customSnackBar(message: e.toString(), error: true);
    }
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
