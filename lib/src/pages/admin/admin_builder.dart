import 'dart:math';

import 'package:animate_icons/animate_icons.dart';
import 'package:budget_controller/src/controller/project_controller.dart';
import 'package:budget_controller/src/controller/user_controller.dart';
import 'package:budget_controller/src/modells/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../const.dart';
import '../../controller/log_controller.dart';
import '../../widget_builder.dart';
import '../owner/const_owner.dart';
import 'const_admin.dart';

class AdminBuilder {
  static addUserPopup({
    required UserController userController,
    required BuildContext context,
  }) {
    ProjectController projectController = Get.find();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final Random generator = Random.secure();
    late String tempPassword = generator.nextDouble().toString();
    String selectedRole = Const.userRoles[0];

    final TextEditingController emailController = TextEditingController();
    late TextEditingController passwordController =
        TextEditingController(text: tempPassword);

    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text(
          CAdmin.addUser,
          style: TextStyle(color: Colors.black),
        ),
        content: StatefulBuilder(builder: (context, setState) {
          AnimateIconController controller = AnimateIconController();
          stateRole({required String art}) {
            selectedRole = art;
            setState(() {});
          }

          stateProject({required String art}) {
            projectController.projectId = art;
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
                                  hint: CAdmin.addUserHints[0],
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
                                  hint: CAdmin.addUserHints[1],
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
                              selectedRole == Const.userRoles[1]
                                  ? FutureBuilder(
                                      future: projectController.loadProjects(),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        return SizedBox(
                                            width: 150,
                                            child: CustomBuilder.popupDropDown(
                                                gewaehlteArt:
                                                    projectController.projectId,
                                                arten: snapshot.data
                                                    ?.map((e) => e.id)
                                                    .toList(),
                                                setArt: stateProject));
                                      })
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
                        projectId: projectController.projectId,
                        context: context);
                    emailController.text = "";
                    passwordController.text = "";
                    selectedRole = Const.userRoles[0];
                    projectController.projectId = null;
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                text: CAdmin.add,
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
          CAdmin.changeRole,
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
                          hint: CAdmin.addUserHints[2],
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
                  text: CAdmin.add,
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
          CAdmin.resetPassword,
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
                        hint: CAdmin.addUserHints[0],
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
                  text: CAdmin.reset,
                )
              ],
            ),
          )
        ]);
  }

  static Widget buildIconBar(
      {required Function setLogHistory,
      required BuildContext context,
      required UserController userController,
      required bool logHistory}) {
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        IconButton(
            onPressed: () {
              setLogHistory(value: false);
            },
            icon: Icon(
              Icons.mail_outline,
              color: logHistory ? Colors.grey : const Color(0xff7434E6),
            )),
        IconButton(
            onPressed: () {
              CustomBuilder.createSubscaffold(
                  context: context,
                  child: AdminBuilder.addUserPopup(
                    context: context,
                    userController: userController,
                  ));
            },
            icon: const Icon(Icons.person_add_outlined, color: Colors.grey)),
        IconButton(
            onPressed: () {
              CustomBuilder.createSubscaffold(
                  context: context,
                  child: AdminBuilder.changeRolePopup(
                    context: context,
                    userController: userController,
                  ));
            },
            icon: const Icon(
              Icons.change_circle_outlined,
              color: Colors.grey,
            )),
        IconButton(
            onPressed: () {
              CustomBuilder.createSubscaffold(
                  context: context,
                  child: AdminBuilder.resetPassword(
                    context: context,
                    userController: userController,
                  ));
            },
            icon: const Icon(
              Icons.key,
              color: Colors.grey,
            )),
        IconButton(
            onPressed: () {
              setLogHistory(value: true);
            },
            icon: Icon(
              Icons.book_outlined,
              color: logHistory ? const Color(0xff7434E6) : Colors.grey,
            )),
      ],
    );
  }

  static Widget buildLogExpansionTile(
      {required Function setTileState,
      required bool value,
      required int index,
      required Log log}) {
    return ExpansionTile(
      title: Row(
        children: [
          Checkbox(
              checkColor: const Color(0xff7434E6),
              activeColor: Colors.transparent,
              value: value,
              onChanged: (curValue) async {
                if (curValue == true) {
                  await LogController.setRead(uid: log.id);

                  setTileState(value: curValue, index: index);
                } else {
                  await LogController.setUnread(uid: log.id);

                  setTileState(value: curValue, index: index);
                }
              }),
          Text(
            log.title,
            style: const TextStyle(color: Colors.black),
          )
        ],
      ),
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${CAdmin.message} ${log.notification}",
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${CAdmin.ticketNum} ${log.id}",
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${CAdmin.from} ${log.date.toString()}",
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
