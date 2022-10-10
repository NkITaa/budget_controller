import 'package:budget_controller/src/controller/project_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widget_builder.dart';
import '../manager_builder.dart';

// shows KPIs to all projects & enables selection of specific project
class KPIs extends StatefulWidget {
  const KPIs({super.key});

  @override
  State<KPIs> createState() => _KPIsState();
}

class _KPIsState extends State<KPIs> {
  ProjectController projectController = Get.find();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: projectController.getProjectIds(),
        builder: (context, snapshot) {
          // Shows ErrorText when Snapshot has an error
          if (snapshot.hasError) {
            return CustomBuilder.defaultFutureError(
                error: snapshot.error.toString());
          }

          // Shows ProgressIndicator during loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: const CircularProgressIndicator());
          }

          final projectIds = snapshot.requireData;

          return Column(
            children: [
              SizedBox(
                  width: 200,
                  child: CustomBuilder.customSearchDropDown(
                    project: true,
                    items: projectIds.map((e) => e!).toList(),
                  )),
              projectController.projectId != null
                  ? FutureBuilder(
                      future: projectController.getProject(
                          projectId: projectController.projectId!),
                      builder: (context, snapshot) {
                        // Shows ErrorText when Snapshot has an error
                        if (snapshot.hasError) {
                          return CustomBuilder.defaultFutureError(
                              error: snapshot.error.toString());
                        }

                        // Shows ProgressIndicator during loading
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              width: MediaQuery.of(context).size.width,
                              child: const CircularProgressIndicator());
                        }

                        final project = snapshot.requireData;

                        return Container();
                      })
                  : Container()
            ],
          );
        });
  }
}
