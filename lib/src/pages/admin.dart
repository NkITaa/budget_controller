import 'package:budget_controller/src/constants/const.dart';
import 'package:budget_controller/src/constants/const_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../controller/UserManagement/user_controller.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserController userController = Get.find();

  String selectedRole = Const.userRoles[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          OutlinedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: const Text(CAdmin.signOut),
          ),
          TextField(
            controller: emailController,
          ),
          const SizedBox(
            height: 4,
          ),
          TextField(
            controller: passwordController,
          ),
          OutlinedButton(
            onPressed: () async {
              await userController.signUp(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                  role: selectedRole,
                  context: context);
              navigatorKey.currentState!.popUntil((route) => route.isFirst);
            },
            child: const Text(""),
          ),
          DropdownButton(
              value: selectedRole,
              items: Const.userRoles
                  .map((String role) => DropdownMenuItem<String>(
                      value: role,
                      child: Text(
                        role,
                      )))
                  .toList(),
              onChanged: (String? role) =>
                  setState(() => selectedRole = role!)),
        ],
      ),
    );
  }
}
