import 'dart:math';

import 'package:budget_controller/src/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../const.dart';
import '../../widget_builder.dart';
import '../owner/const_owner.dart';

class AdminBuilder {
  static addUserPopup({
    required String selectedRole,
    required List<String> selectedProjects,
    required UserController userController,
    required BuildContext context,
    required Function stateRole,
    required Function stateProjects,
  }) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final Random generator = Random.secure();
    late String tempPassword = generator.nextDouble().toString();

    final TextEditingController emailController = TextEditingController();
    late TextEditingController passwordController =
        TextEditingController(text: tempPassword);

    return Get.defaultDialog(
        title: "Benutzer Hinzufügen",
        titleStyle: const TextStyle(color: Colors.black),
        content: SizedBox(
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
                          ),
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
                          SizedBox(
                              width: 150,
                              child: CustomBuilder.popupDropDownList(
                                  gewaehlteArten: selectedProjects,
                                  arten: ["a", "b", "c", "d"],
                                  setArten: stateProjects)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
                      Get.back();
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
    required String selectedRole,
    required UserController userController,
    required BuildContext context,
    required Function state,
  }) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController userController = TextEditingController();
    return Get.defaultDialog(
        title: "Rolle ändern",
        titleStyle: const TextStyle(color: Colors.black),
        content: SizedBox(
            height: 160,
            width: 250,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                    key: formKey,
                    child: Column(children: [
                      CustomBuilder.popUpTextField(
                        controller: userController,
                        hint: "User ID",
                        isUid: true,
                      ),
                      SizedBox(
                          width: 210,
                          child: CustomBuilder.popupDropDown(
                            arten: Const.userRoles,
                            gewaehlteArt: selectedRole,
                            setArt: state,
                          )),
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Get.back();
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
