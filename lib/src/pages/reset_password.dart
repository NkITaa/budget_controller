import 'package:budget_controller/src/widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../Constants/const_resetpassword.dart';
import '../controller/UserManagement/user_controller.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController emailController = TextEditingController();

  final UserController userController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Form(
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                CustomBuilder.customLogo(size: 250),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 230,
                      ),
                      const Text(
                        CRPassword.resetHeadline,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomBuilder.customTextFormField(
                          controller: emailController,
                          hint: CRPassword.mailHint,
                          password: false),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomBuilder.customButton(
                        text: CRPassword.reset,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await userController.resetPassword(
                                email: emailController.text, context: context);
                            navigatorKey.currentState!
                                .popUntil((route) => route.isFirst);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
