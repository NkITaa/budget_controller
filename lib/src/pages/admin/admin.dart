import 'package:budget_controller/src/controller/log_controller.dart';
import 'package:budget_controller/src/controller/user_controller.dart';
import 'package:budget_controller/src/pages/admin/admin_builder.dart';
import 'package:budget_controller/src/widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modells/log.dart';
import '../../modells/user.dart';
import 'const_admin.dart';

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

  setLogHistory({required bool value}) {
    logHistory = value;
    setState(() {});
  }

  setTileState({required bool value, required int index}) {
    tileState[index] = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
              logHistory ? CAdmin.logHistory : CAdmin.logs,
              style: const TextStyle(fontSize: 28, color: Colors.black),
            )),
            Flexible(
              child: Row(
                children: [
                  AdminBuilder.buildIconBar(
                      setLogHistory: setLogHistory,
                      context: context,
                      userController: userController,
                      logHistory: logHistory),
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
                                return CustomBuilder.defaultFutureError(
                                    error: snapshot.error.toString());
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    width: MediaQuery.of(context).size.width,
                                    child: const CircularProgressIndicator());
                              }

                              final logs = snapshot.requireData;
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 170,
                                child: ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: logs!.length,
                                  itemBuilder: (context, index) {
                                    Log log = logs[index];
                                    tileState.add(log.read);
                                    if (logHistory) {
                                      return AdminBuilder.buildLogExpansionTile(
                                          setTileState: setTileState,
                                          value: tileState[index]!,
                                          log: log,
                                          index: index);
                                    } else {
                                      if (!tileState[index]!) {
                                        return AdminBuilder
                                            .buildLogExpansionTile(
                                                setTileState: setTileState,
                                                value: tileState[index]!,
                                                log: log,
                                                index: index);
                                      } else {
                                        return Container();
                                      }
                                    }
                                  },
                                ),
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
    );
  }
}
