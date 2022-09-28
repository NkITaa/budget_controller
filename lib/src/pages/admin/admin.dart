import 'package:budget_controller/src/controller/log_controller.dart';
import 'package:budget_controller/src/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modells/log.dart';
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
  List<bool?> tileState = [];
  bool logHistory = false;

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
              Center(
                  child: Text(
                logHistory ? "Log-Historie" : "Nachrichten",
                style: const TextStyle(fontSize: 28, color: Colors.black),
              )),
              Flexible(
                child: Row(
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        IconButton(
                            onPressed: () {
                              logHistory = false;
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.mail_outline,
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
                                              child:
                                                  AdminBuilder.changeRolePopup(
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
                        IconButton(
                            onPressed: () {
                              logHistory = true;
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.book_outlined,
                              color: Colors.grey,
                            )),
                      ],
                    ),
                    Flexible(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 130,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
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
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                final logs = snapshot.requireData;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: logs!.length,
                                  itemBuilder: (context, index) {
                                    Log log = logs[index];
                                    tileState.add(log.read);
                                    if (logHistory) {
                                      return ExpansionTile(
                                        title: Row(
                                          children: [
                                            Checkbox(
                                                checkColor:
                                                    const Color(0xff7434E6),
                                                activeColor: Colors.transparent,
                                                value: tileState[index],
                                                onChanged: (curValue) async {
                                                  if (curValue = true) {
                                                    tileState[index] = curValue;
                                                    await LogController.setRead(
                                                        uid: log.id);
                                                    setState(() {});
                                                  } else {
                                                    null;
                                                  }
                                                }),
                                            Text(
                                              log.notification,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Ticket Nummer: ${log.id}",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                "Von UserID: ${log.userId}",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                "Vom: ${log.date.toString()}",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                "Projekt: ${log.projectId}",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                log.projectId ?? "",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    } else {
                                      if (!tileState[index]!) {
                                        return ExpansionTile(
                                          title: Row(
                                            children: [
                                              Checkbox(
                                                  value: tileState[index],
                                                  onChanged: (curValue) async {
                                                    if (curValue = true) {
                                                      tileState[index] =
                                                          curValue;
                                                      await LogController
                                                          .setRead(uid: log.id);
                                                      setState(() {});
                                                    } else {
                                                      null;
                                                    }
                                                  }),
                                              Text(
                                                log.notification,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Ticket Nummer: ${log.id}",
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "Von UserID: ${log.userId}",
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "Vom: ${log.date.toString()}",
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "Projekt: ${log.projectId}",
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  log.projectId ?? "",
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
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
