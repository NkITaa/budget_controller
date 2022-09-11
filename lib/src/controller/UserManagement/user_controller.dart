import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../widget_builder.dart';

class UserController extends GetxController {
  Future<String> signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    CustomBuilder.customProgressIndicator(context: context);
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return await getRole();
    } on FirebaseAuthException catch (e) {
      CustomBuilder.customSnackBar(message: e.toString(), error: true);
      return e.toString();
    }
  }

  Future<void> signUp(
      {required String email,
      required String password,
      required String role,
      required BuildContext context}) async {
    CustomBuilder.customProgressIndicator(context: context);
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await createUser(uid: FirebaseAuth.instance.currentUser!.uid, role: role);
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

  Future<void> createUser({required String uid, required String role}) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection("user");
    try {
      await userCollection.doc(uid).set({
        "role": role,
      });
    } on FirebaseAuthException catch (e) {
      CustomBuilder.customSnackBar(message: e.toString(), error: true);
    }
  }

  Future<String> getRole() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection("user");

    return userCollection.doc(uid).get().then((value) {
      return value["role"];
    });
  }
}
