import 'package:budget_controller/src/constants/const_login.dart';
import 'package:budget_controller/src/controller/user_controller.dart';
import 'package:budget_controller/src/pages/reset_password.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../widget_builder.dart';

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
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              CustomBuilder.customLogo(size: 250),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 200,
                    ),
                    const Text(CLogin.login,
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 400,
                        child: Text(CLogin.mailHeading),
                      ),
                    ),
                    CustomBuilder.customTextFormField(
                        controller: emailController,
                        hint: CLogin.mailHint,
                        password: false),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 400,
                        child: Text(CLogin.passwordHeading),
                      ),
                    ),
                    CustomBuilder.customTextFormField(
                        controller: passwordController,
                        hint: CLogin.passwordHint,
                        password: true),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                          text: TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ResetPassword())),
                              text: CLogin.fPassword,
                              style: const TextStyle(color: Colors.white))),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
