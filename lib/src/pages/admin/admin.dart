import 'package:budget_controller/src/controller/log_controller.dart';
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

  bool value = false;

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
              FutureBuilder(
                future: LogController.loadLogs(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasError) {
                    snapshot.printError();
                    return Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Text(
                          snapshot.error.toString(),
                          style: const TextStyle(
                              fontSize: 30, color: Colors.black),
                        ),
                      ],
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final data = snapshot.requireData;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        title: Row(
                          children: [
                            Checkbox(
                                value: value,
                                onChanged: (curValue) {
                                  value = curValue!;
                                  setState(() {});
                                }),
                            Text(
                              data[index].notification,
                              style: const TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                        children: [
                          Column(
                            children: [
                              Text(
                                "Ticket Nummer: ${data[index].id}",
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                "Von UserID: ${data[index].userId}",
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                "Vom: ${data[index].date.toString()}",
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                "Projekt: ${data[index].projectId}",
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                data[index].projectId ?? "",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
