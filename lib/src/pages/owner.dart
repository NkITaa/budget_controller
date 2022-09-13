import 'package:budget_controller/src/constants/const_owner.dart';
import 'package:budget_controller/src/modells/project.dart';
import 'package:budget_controller/src/modells/projection.dart';
import 'package:budget_controller/src/modells/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/project_controller.dart';

class Owner extends StatefulWidget {
  const Owner({super.key});

  @override
  State<Owner> createState() => _OwnerState();
}

class _OwnerState extends State<Owner> {
  ProjectController projectController = Get.put(ProjectController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Owner"),
        OutlinedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: const Text(COwner.signOut),
        ),
        OutlinedButton(
          onPressed: () {
            projectController.createProject(
                project: Project(
                    id: "id",
                    name: "name",
                    ownersId: ["id"],
                    costs: [],
                    projections: [Projection(type: "type", value: 2)]));
          },
          child: const Text("bo"),
        ),
      ],
    );
  }
}
