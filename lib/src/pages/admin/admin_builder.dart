import 'dart:math';

import 'package:budget_controller/src/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../main.dart';
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
    List<String>? selectedProjects;

    final TextEditingController emailController = TextEditingController();
    late TextEditingController passwordController =
        TextEditingController(text: tempPassword);

    return Get.defaultDialog(
        title: "Benutzer Hinzufügen",
        titleStyle: const TextStyle(color: Colors.black),
        content: StatefulBuilder(builder: (context, setState) {
          stateRole({required String art}) {
            selectedRole = art;
            setState(() {});
          }

          stateProjects({required List<String> arten}) {
            selectedProjects = arten;
            setState(() {});
          }

          return SizedBox(
              height: 200,
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
                              IconButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: passwordController.text));
                                  },
                                  icon: const Icon(
                                    Icons.copy_all_outlined,
                                    color: Colors.black,
                                  )),
                              const SizedBox(
                                width: 30,
                              ),
                              selectedRole == "Owner"
                                  ? SizedBox(
                                      width: 150,
                                      child: CustomBuilder.popupDropDownList(
                                          gewaehlteArten: selectedProjects,
                                          arten: ["a", "b", "c", "d"],
                                          setArten: stateProjects))
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
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await userController.signUp(
                          email: emailController.text,
                          password: passwordController.text,
                          role: selectedRole,
                          projectsId: selectedProjects,
                          context: context);

                      navigatorKey.currentState!
                          .popUntil((route) => route.isFirst);
                    }
                  },
                  text: "Hinzufügen",
                )
              ],
            ),
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
    return Get.defaultDialog(
        title: "Rolle ändern",
        titleStyle: const TextStyle(color: Colors.black),
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
                            width: 210,
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      userController.changeRole(
                          uid: idController.text,
                          role: selectedRole,
                          context: context);
                      navigatorKey.currentState!
                          .popUntil((route) => route.isFirst);
                    }
                  },
                  text: "Hinzufügen",
                )
              ],
            ),
          )
        ]);
  }
}
