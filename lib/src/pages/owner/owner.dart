import 'package:budget_controller/src/modells/cost.dart';
import 'package:budget_controller/src/modells/project.dart';
import 'package:budget_controller/src/pages/owner/components/table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/project_controller.dart';
import '../../modells/user.dart';
import 'components/owner_builder.dart';

class Owner extends StatefulWidget {
  const Owner({super.key, required this.user});
  final CustomUser user;

  @override
  State<Owner> createState() => _OwnerState();
}

class _OwnerState extends State<Owner> {
  ProjectController projectController = Get.put(ProjectController());
  bool enabled = false;
  int currentIndex = 0;
  Project? project;

  void toggle({required int index}) {
    currentIndex = index;
    enabled = !enabled;
    setState(() {});
  }

  void state() {
    setState(() {});
  }

  int sortColumnIndex = 0;
  bool sortAscending = true;

  void sort<T>(
    Comparable<T> Function(Cost d) getField,
    int columnIndex,
    bool ascending,
    TableData source,
  ) {
    source.sortMe<T>(getField, ascending);
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Beispiel Projekt",
                style: TextStyle(fontSize: 25, color: Colors.black),
              ),
              OwnerBuilder.buildComparison(
                  isPrice: 16, shouldPrice: 20, context: context),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OwnerBuilder.buildTable(
                    state: state,
                    context: context,
                    cells: ["cells"],
                    enabled: enabled,
                    currentIndex: currentIndex,
                    toggle: toggle,
                    sort: sort,
                    sortAscending: sortAscending,
                    sortColumnIndex: sortColumnIndex),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
