import 'package:budget_controller/src/pages/manager/components/kpis.dart';
import 'package:budget_controller/src/pages/manager/components/new_project.dart';
import 'package:budget_controller/src/pages/manager/components/project.dart';
import 'package:flutter/material.dart';

import '../../modells/user.dart';

class Manager extends StatefulWidget {
  const Manager({super.key, required this.user});
  final CustomUser user;
  @override
  State<Manager> createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  int selectedIndex = 0;
  List<Widget> pages = [const KPIs(), const Project(), const NewProject()];
  List<String> title = ["KPIs", "Projekt XYZ", "Projekt anlegen"];

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
            Stack(
              children: [
                Center(
                    child: Text(
                  title[selectedIndex],
                  style: const TextStyle(fontSize: 28, color: Colors.black),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          selectedIndex = 0;
                          setState(() {});
                        },
                        icon: const Icon(Icons.bar_chart_outlined,
                            color: Colors.grey)),
                    IconButton(
                        onPressed: () {
                          selectedIndex = 1;
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.file_copy,
                          color: Colors.grey,
                        )),
                    IconButton(
                        onPressed: () {
                          selectedIndex = 2;
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.grey,
                        )),
                  ],
                ),
              ],
            ),
            pages[selectedIndex]
          ],
        ),
      ),
    );
  }
}
