import 'package:budget_controller/src/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modells/user.dart';
import 'admin_builder.dart';

class Admin extends StatefulWidget {
  const Admin({super.key, required this.user});
  final CustomUser user;
  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 70,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  const Center(
                      child: Text(
                    "Nachrichten",
                    style: TextStyle(fontSize: 28, color: Colors.black),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ScaffoldMessenger(
                                  child: Builder(
                                    builder: (context) => Scaffold(
                                      backgroundColor: Colors.transparent,
                                      body: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: GestureDetector(
                                            onTap: () {},
                                            child: AdminBuilder.addUserPopup(
                                              context: context,
                                              userController: userController,
                                            )),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.person_add_outlined,
                              color: Colors.grey)),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ScaffoldMessenger(
                                  child: Builder(
                                    builder: (context) => Scaffold(
                                      backgroundColor: Colors.transparent,
                                      body: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: GestureDetector(
                                            onTap: () {},
                                            child: AdminBuilder.changeRolePopup(
                                              context: context,
                                              userController: userController,
                                            )),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.change_circle_outlined,
                            color: Colors.grey,
                          )),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ScaffoldMessenger(
                                  child: Builder(
                                    builder: (context) => Scaffold(
                                      backgroundColor: Colors.transparent,
                                      body: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: GestureDetector(
                                            onTap: () {},
                                            child: AdminBuilder.resetPassword(
                                              context: context,
                                              userController: userController,
                                            )),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.key_outlined,
                            color: Colors.grey,
                          )),
                    ],
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: ((context, index) {
                  return const ListTile();
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
