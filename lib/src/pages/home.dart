import 'package:budget_controller/src/modells/user.dart';
import 'package:budget_controller/src/pages/admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/const.dart';
import '../controller/user_controller.dart';
import 'manager.dart';
import 'owner.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserController userController = Get.find();
  late Future<CustomUser> user = userController.getUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<CustomUser>(
      future: user,
      builder: (
        BuildContext context,
        AsyncSnapshot<CustomUser> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            CustomUser user = snapshot.data!;
            if (user.role == Const.userRoles[0]) {
              return Manager(
                user: user,
              );
            }
            if (user.role == Const.userRoles[1]) {
              return Owner(
                user: user,
              );
            }
            if (user.role == Const.userRoles[2]) {
              return Admin(
                user: user,
              );
            } else {
              return const Center(
                  child: Text(
                Const.unknownError,
              ));
            }
          }
        } else {
          return Center(child: Text('State: ${snapshot.connectionState}'));
        }
      },
    ));
  }
}
