import 'package:budget_controller/src/controller/log_controller.dart';
import 'package:budget_controller/src/controller/user_controller.dart';
import 'package:budget_controller/src/pages/admin/admin_builder.dart';
import 'package:budget_controller/src/widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modells/log.dart';
import '../../modells/user.dart';
import 'const_admin.dart';

// Skeleton of Admin Page
class Admin extends StatefulWidget {
  const Admin({super.key, required this.user});

  // Current User Object
  final CustomUser user;
  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  // Enables access to all methods of the userController
  UserController userController = Get.find();

  // Gives info on whether a log has been read or not
  List<bool?> tileState = [];

  // Says whether the logHistory is depicted or not
  bool logHistory = false;

  // Enables child-widget to update the value of the logHistory
  setLogHistory({required bool value}) {
    // Updates the logHistories value
    logHistory = value;

    // Sets state so the changement can be seen
    setState(() {});
  }

  // Enables child-widget to update the value of a tileState
  setTileState({required bool value, required int index}) {
    // Updates the specific tileState value
    tileState[index] = value;

    // Sets state so the changement can be seen
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

            /// Header of the page consisting of
            ///
            /// * title
            Center(
                child: Text(
              logHistory ? CAdmin.logHistory : CAdmin.logs,
              style: const TextStyle(fontSize: 28, color: Colors.black),
            )),

            /// Body of the page consists of a row with:
            ///
            /// * an IconBar, that enables all the admins actions
            /// * a ListView that builds all the relevant logs
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

                          // Is responsible for handling the future Logs
                          FutureBuilder(
                            future: LogController.loadLogs(),
                            builder: (BuildContext context, snapshot) {
                              // Shows ErrorText when Snapshot has an error
                              if (snapshot.hasError) {
                                return CustomBuilder.defaultFutureError(
                                    error: snapshot.error.toString());
                              }

                              // Shows ProgressIndicator during loading
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    width: MediaQuery.of(context).size.width,
                                    child: const CircularProgressIndicator());
                              }

                              final logs = snapshot.requireData;

                              /// Build the logs in a ListView
                              ///
                              /// * LogHistory == true -> all Logs are shown
                              /// * LogHistory == false -> only the relevant Logs are shown
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
