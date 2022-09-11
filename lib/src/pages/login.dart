import 'package:budget_controller/src/controller/UserManagement/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                await userController.signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    context: context);
                navigatorKey.currentState!.popUntil((route) => route.isFirst);
              },
              child: const Text("Anmelden"))
        ],
      ),
    );
  }
}
