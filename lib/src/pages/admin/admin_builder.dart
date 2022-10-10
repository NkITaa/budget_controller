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

// Defines Widget Pieces that are used across the Admin UI
class AdminBuilder {
  // returns the popup that enables the creation of a new user
  static addUserPopup({
    required UserController userController,
    required BuildContext context,
  }) {
    // enables access to projectController methods
    ProjectController projectController = Get.find();

    // formKey that validates the input in controller
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // autogenerates password
    final Random generator = Random.secure();
    late String tempPassword = generator.nextDouble().toString();

    // defaultly selected role in dropdown
    String selectedRole = Const.userRoles[0];

    // TextEditing controller for the mail of the new User
    final TextEditingController emailController = TextEditingController();

    // TextEditing controller for the password of the new User
    late TextEditingController passwordController =
        TextEditingController(text: tempPassword);

    return AlertDialog(
      title: const Text(
        CAdmin.addUser,
        style: TextStyle(color: Colors.black),
      ),
      content: StatefulBuilder(builder: (context, setState) {
        // Animation Controller to handle copy animation
        AnimateIconController controller = AnimateIconController();

        // updates the selected role
        stateRole({required String type}) {
          // the chosen type is written into the selected role variable
          selectedRole = type;

          // the state is called to register the new value graphically
          setState(() {});
        }

        // updates the selected projectId
        stateProject({required String type}) {
          // the chosen type is written into the selected projectId variable
          projectController.projectId = type;

          // the state is called to register the new value graphically
          setState(() {});
        }

        /// Content of the Dialog is shown, with two rows
        ///
        /// * 1. row: Mail TextField & DropDown to chose a role
        /// * 2. row: Password TextField & optional DropDown (UserRole == Owner), where the user can be assigned to an project without owner
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
                            child: CustomBuilder.defaultTextField(
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
                              types: Const.userRoles,
                              chosenType: selectedRole,
                              setType: stateRole,
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
                              child: CustomBuilder.defaultTextField(
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
                                    builder: (BuildContext context, snapshot) {
                                      return SizedBox(
                                          width: 150,
                                          child: CustomBuilder.popupDropDown(
                                              chosenType:
                                                  projectController.projectId,
                                              types: snapshot.data
                                                  ?.map((e) => e.id)
                                                  .toList(),
                                              setType: stateProject));
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

      /// defines the actions in the dialog
      ///
      /// * back -> closes popUp
      /// * add -> Form gets validates, data is added to Firebase & all the controllers are reset
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
      ],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
    );
  }

  // enables the change of a user Role
  static changeRolePopup({
    required UserController userController,
    required BuildContext context,
  }) {
    // formKey that validates the input in controller
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // textEditingController for the userId of the specific user
    final TextEditingController idController = TextEditingController();

    // defaultly selected role in dropdown
    String selectedRole = Const.userRoles[0];
    return AlertDialog(
      title: const Text(
        CAdmin.changeRole,
        style: TextStyle(color: Colors.black),
      ),
      content: StatefulBuilder(builder: (context, setState) {
        // updates the selected role
        stateRole({required String type}) {
          // the chosen type is written into the selected row variable
          selectedRole = type;

          // the state is called to also update the value graphically
          setState(() {});
        }

        /// returns the contens of the PopUp, consisting of a Column, with:
        ///
        /// * a TextField where the user id is inserted into
        /// * a DropDown, where the specific role is selected
        return SizedBox(
            height: 160,
            width: 250,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                    key: formKey,
                    child: Column(children: [
                      CustomBuilder.defaultTextField(
                        controller: idController,
                        hint: CAdmin.addUserHints[2],
                        isUid: true,
                      ),
                      SizedBox(
                          width: 225,
                          child: CustomBuilder.popupDropDown(
                            types: Const.userRoles,
                            chosenType: selectedRole,
                            setType: stateRole,
                          )),
                    ]))));
      }),

      /// defines the actions in the dialog
      ///
      /// * back -> closes popUp
      /// * add -> Form gets validates, data is added to Firebase & all the controllers are reset
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
      ],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
    );
  }

  // returns PopUp with that a user password can be reset
  static resetPassword({
    required UserController userController,
    required BuildContext context,
  }) {
    // formKey that validates the input in controller
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // textEditingController for the email of the specific user
    final TextEditingController emailController = TextEditingController();
    return AlertDialog(
      title: const Text(
        CAdmin.resetPassword,
        style: TextStyle(color: Colors.black),
      ),

      /// returns the contens of the PopUp, consisting of:
      ///
      /// * a TextField where the user mail is inserted into
      content: SizedBox(
          height: 90,
          width: 250,
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: formKey,
                  child: Column(children: [
                    CustomBuilder.defaultTextField(
                      controller: emailController,
                      hint: CAdmin.addUserHints[0],
                    ),
                  ])))),

      /// defines the actions in the dialog
      ///
      /// * back -> closes popUp
      /// * add -> Form gets validates, the reset mail is sent & the controller gets reset
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
      ],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
    );
  }

  // returns the IconBar where the Admin can fulfill his Actions
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

        // sets the logHistory to false -> Logs that are unread are shown
        IconButton(
            onPressed: () {
              setLogHistory(value: false);
            },
            icon: Icon(
              Icons.mail_outline,
              color: logHistory ? Colors.grey : const Color(0xff7434E6),
            )),

        // opens the addUserPopup popUp -> a new user can get created
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

        // opens the changeRolePopup popUp -> the user can role can be changed
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

        // opens the resetPassword popUp -> a user resetmail can be send
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

        // sets the logHistory to true -> All Logs are shown
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

  // builds the ListTile of each log
  static Widget buildLogExpansionTile(
      {required Function setTileState,
      required bool value,
      required int index,
      required Log log}) {
    /// the Log itself Consists of:
    ///
    /// * Title
    /// * Body
    return ExpansionTile(
      /// the title consists of a row:
      ///
      /// * with a CheckBox: when
      ///     * set to check -> log gets set to read
      ///     * set to unchecked -> lo9g gets set to unread
      /// * and a title
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
            style: TextStyle(color: log.warning ? Colors.yellow : Colors.black),
          )
        ],
      ),

      /// the body consists of a Column with three parts:
      ///
      /// * the Logs message
      /// * the Logs id
      /// * the Logs creation-date
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${Const.message} ${log.notification}",
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${Const.ticketNum} ${log.id}",
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${Const.from} ${log.date.toString()}",
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
