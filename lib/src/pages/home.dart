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
  late Future<String> role = userController.getRole();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<String>(
      future: role,
      builder: (
        BuildContext context,
        AsyncSnapshot<String> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            if (snapshot.data == Const.userRoles[0]) {
              return const Manager();
            }
            if (snapshot.data == Const.userRoles[1]) {
              return const Owner();
            }
            if (snapshot.data == Const.userRoles[2]) {
              return const Admin();
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
