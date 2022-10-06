import 'package:budget_controller/src/pages/login/const_login.dart';
import 'package:budget_controller/src/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../widget_builder.dart';
import 'login_builder.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                CustomBuilder.customLogo(size: 100),
                const Text(CLogin.login,
                    style: TextStyle(color: Colors.white, fontSize: 30)),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 8),
                  child: SizedBox(
                    width: 400,
                    child: Text(CLogin.mailHeading),
                  ),
                ),
                LoginBuilder.textFormField(
                  controller: emailController,
                  hint: CLogin.mailHint,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 8),
                  child: SizedBox(
                    width: 400,
                    child: Text(CLogin.passwordHeading),
                  ),
                ),
                LoginBuilder.textFormField(
                    controller: passwordController,
                    hint: CLogin.passwordHint,
                    isPassword: true),
                CustomBuilder.customButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await userController.signIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            context: context);
                        navigatorKey.currentState!
                            .popUntil((route) => route.isFirst);
                      }
                    },
                    text: CLogin.login),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
