import 'package:budget_controller/src/controller/project_controller.dart';
import 'package:budget_controller/src/pages/manager/manager_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widget_builder.dart';

// shows KPIs to all projects & enables selection of specific project
class KPIs extends StatefulWidget {
  const KPIs({super.key});

  @override
  State<KPIs> createState() => _KPIsState();
}

class _KPIsState extends State<KPIs> {
  // Enables access to all Methods in the projectController
  ProjectController projectController = Get.find();

  // enables stateSetting from child-widget
  void state() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Handles the getProjectIds Future
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
              // Enables selection of specific projectId
              SizedBox(
                  width: 200,
                  child: CustomBuilder.customSearchDropDown(
                    state: state,
                    project: true,
                    items: projectIds.map((e) => e!).toList(),
                  )),
              // only when a projectId is chosen a project preview is shown
              projectController.projectId != null
                  ? ManagerBuilder.showPreview(
                      context: context, projectController: projectController)
                  : Container()
            ],
          );
        });
  }
}
