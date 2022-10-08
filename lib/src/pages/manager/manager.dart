import 'package:budget_controller/src/pages/manager/components/kpis.dart';
import 'package:budget_controller/src/pages/manager/components/new_project.dart';
import 'package:flutter/material.dart';

import '../../modells/user.dart';
import 'components/messages.dart';
import 'const_manager.dart';

// Skeleton for all Manager Screens
class Manager extends StatefulWidget {
  const Manager({super.key, required this.user});
  final CustomUser user;
  @override
  State<Manager> createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  // is the Index of the Page that is selected
  int selectedIndex = 0;

  // holds List of all Pages
  List<Widget> pages = [const KPIs(), const NewProject(), const Messages()];

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
                //Title of specific Page
                Center(
                    child: Text(
                  CManager.titles[selectedIndex],
                  style: const TextStyle(fontSize: 28, color: Colors.black),
                )),

                /// Row of Navigation Icons
                ///
                /// * Icon: bar_chart_outlined -> sets Index to 3: KPIs Screen
                /// * Icon: add -> sets Index to 3: NewProject Screen
                /// * Icon: mail_outline -> sets Index to 3: Messages Screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          selectedIndex = 0;
                          setState(() {});
                        },
                        icon: Icon(Icons.bar_chart_outlined,
                            color: selectedIndex == 0
                                ? const Color(0xff7434E6)
                                : Colors.grey)),
                    IconButton(
                        onPressed: () {
                          selectedIndex = 1;
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.add,
                          color: selectedIndex == 1
                              ? const Color(0xff7434E6)
                              : Colors.grey,
                        )),
                    IconButton(
                        onPressed: () {
                          selectedIndex = 2;
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.mail_outline,
                          color: selectedIndex == 2
                              ? const Color(0xff7434E6)
                              : Colors.grey,
                        )),
                  ],
                ),
              ],
            ),

            // returns the specific page
            pages[selectedIndex]
          ],
        ),
      ),
    );
  }
}
