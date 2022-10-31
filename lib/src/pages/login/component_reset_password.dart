import 'package:budget_controller/src/widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../controller/user_controller.dart';
import 'const_login.dart';
import 'login_builder.dart';

// Defines page that enables to send a password reset mail to user
class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  // Value of email TextField is controlled here
  final TextEditingController emailController = TextEditingController();

  // Enables usage of userController methods
  final UserController userController = Get.find();

  // FormKey that validates the input in controller
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Whole Reset PasswordScreen, consisting of
  ///
  /// * Logo
  /// * Email Field
  /// * Submit button, that sends resetmail to adress, when the form of the controller is valid
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Form(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  CustomBuilder.customLogo(size: 100),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    CLogin.resetHeadline,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  LoginBuilder.textFormField(
                    controller: emailController,
                    hint: CLogin.mailHint,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomBuilder.customButton(
                    text: CLogin.reset,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        SnackBar snackBar = await userController.resetPassword(
                            email: emailController.text, context: context);
                        CustomBuilder.showSnackBarObject(snackBar: snackBar);
                        navigatorKey.currentState!
                            .popUntil((route) => route.isFirst);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
