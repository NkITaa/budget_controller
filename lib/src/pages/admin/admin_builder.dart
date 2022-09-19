import 'dart:math';

import 'package:animate_icons/animate_icons.dart';
import 'package:budget_controller/src/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../const.dart';
import '../../widget_builder.dart';
import '../owner/const_owner.dart';

class AdminBuilder {
  static addUserPopup({
    required UserController userController,
    required BuildContext context,
  }) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final Random generator = Random.secure();
    late String tempPassword = generator.nextDouble().toString();
    String selectedRole = Const.userRoles[0];
    String selectedProject = Const.userRoles[0];

    final TextEditingController emailController = TextEditingController();
    late TextEditingController passwordController =
        TextEditingController(text: tempPassword);

    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text(
          "Benutzer Hinzufügen",
          style: TextStyle(color: Colors.black),
        ),
        content: StatefulBuilder(builder: (context, setState) {
          AnimateIconController controller = AnimateIconController();
          stateRole({required String art}) {
            selectedRole = art;
            setState(() {});
          }

          stateProject({required String art}) {
            selectedProject = art;
            setState(() {});
          }

          return SizedBox(
              height: 180,
              width: 500,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Flexible(
                              child: CustomBuilder.popUpTextField(
                                  controller: emailController,
                                  hint: "User Mail",
                                  isMail: true),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            SizedBox(
                              width: 150,
                              child: CustomBuilder.popupDropDown(
                                arten: Const.userRoles,
                                gewaehlteArt: selectedRole,
                                setArt: stateRole,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 224,
                                child: CustomBuilder.popUpTextField(
                                  controller: passwordController,
                                  hint: "User Passwort",
                                ),
                              ),
                              CustomBuilder.animateCheckmark(
                                  isDark: true,
                                  controller: controller,
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: passwordController.text));
                                    return true;
                                  }),
                              const SizedBox(
                                width: 30,
                              ),
                              selectedRole == "Owner"
                                  ? SizedBox(
                                      width: 150,
                                      child: CustomBuilder.popupDropDown(
                                          gewaehlteArt: selectedProject,
                                          arten: Const.userRoles,
                                          setArt: stateProject))
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        }),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomBuilder.customButton(
                  onPressed: () {
                    Get.back();
                  },
                  text: COwner.close),
              const SizedBox(
                width: 10,
              ),
              CustomBuilder.customButton(
                onPressed: ([bool mounted = true]) async {
                  if (formKey.currentState!.validate()) {
                    SnackBar snackBar = await userController.signUp(
                        email: emailController.text,
                        password: passwordController.text,
                        role: selectedRole,
                        projectid: selectedProject,
                        context: context);
                    emailController.text = "";
                    passwordController.text = "";
                    selectedRole = Const.userRoles[0];
                    selectedProject = Const.userRoles[0];
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                text: "Hinzufügen",
              )
            ],
          )
        ]);
  }

  static changeRolePopup({
    required UserController userController,
    required BuildContext context,
  }) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController idController = TextEditingController();
    String selectedRole = Const.userRoles[0];
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text(
          "Rolle ändern",
          style: TextStyle(color: Colors.black),
        ),
        content: StatefulBuilder(builder: (context, setState) {
          stateRole({required String art}) {
            selectedRole = art;
            setState(() {});
          }

          return SizedBox(
              height: 160,
              width: 250,
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                      key: formKey,
                      child: Column(children: [
                        CustomBuilder.popUpTextField(
                          controller: idController,
                          hint: "User ID",
                          isUid: true,
                        ),
                        SizedBox(
                            width: 225,
                            child: CustomBuilder.popupDropDown(
                              arten: Const.userRoles,
                              gewaehlteArt: selectedRole,
                              setArt: stateRole,
                            )),
                      ]))));
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomBuilder.customButton(
                    onPressed: () {
                      Get.back();
                    },
                    text: COwner.close),
                const SizedBox(
                  width: 10,
                ),
                CustomBuilder.customButton(
                  onPressed: ([bool mounted = true]) async {
                    if (formKey.currentState!.validate()) {
                      SnackBar snackBar = await userController.changeRole(
                          uid: idController.text,
                          role: selectedRole,
                          context: context);
                      idController.text = "";
                      selectedRole = Const.userRoles[0];
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  text: "Hinzufügen",
                )
              ],
            ),
          )
        ]);
  }

  static resetPassword({
    required UserController userController,
    required BuildContext context,
  }) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text(
          "Passwort zurücksätzen",
          style: TextStyle(color: Colors.black),
        ),
        content: SizedBox(
            height: 90,
            width: 250,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                    key: formKey,
                    child: Column(children: [
                      CustomBuilder.popUpTextField(
                        controller: emailController,
                        hint: "User Email",
                      ),
                    ])))),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomBuilder.customButton(
                    onPressed: () {
                      Get.back();
                    },
                    text: COwner.close),
                const SizedBox(
                  width: 10,
                ),
                CustomBuilder.customButton(
                  onPressed: ([bool mounted = true]) async {
                    if (formKey.currentState!.validate()) {
                      SnackBar snackBar = await userController.resetPassword(
                          email: emailController.text, context: context);
                      emailController.text = "";
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  text: "Zurücksetzen",
                )
              ],
            ),
          )
        ]);
  }
}
