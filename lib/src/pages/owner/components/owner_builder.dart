import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widget_builder.dart';
import 'table.dart';
import '../const_owner.dart';
import '../../../modells/cost.dart';
import 'detaills.dart';

class OwnerBuilder {
  static List<Cost> costs = [
    Cost(
        responsibility: "responsibility",
        name: "name",
        type: "type",
        value: 3,
        creation: Timestamp.now()),
    Cost(
        responsibility: "responsibility",
        name: "name",
        type: "type",
        value: 5,
        creation: Timestamp.now())
  ];

  static Widget buildComparison(
      {required double isPrice,
      required double shouldPrice,
      required BuildContext context}) {
    bool critical = false;
    isPrice / shouldPrice > COwner.criticalPercentile
        ? critical = true
        : critical = false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 4, right: 4, bottom: 4),
              child: Text(
                COwner.isPrice,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Text("${isPrice.toStringAsFixed(2)}€",
                  style: TextStyle(
                      color: critical ? Colors.red : Colors.green,
                      fontSize: 22)),
            )
          ],
        ),
        const SizedBox(
          width: 50,
        ),
        Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 4, right: 4, bottom: 4),
              child: Text(
                COwner.shouldPrice,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text("${shouldPrice.toStringAsFixed(2)}€",
                  style: const TextStyle(color: Colors.black, fontSize: 22)),
            )
          ],
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          color: const Color(0xff7434E6),
          iconSize: 30,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Detaills())),
        ),
      ],
    );
  }

  static Widget buildTable({
    required List<String> cells,
    required bool enabled,
    required bool sortAscending,
    required int sortColumnIndex,
    required int currentIndex,
    required Function toggle,
    required Function sort,
  }) {
    int rowsPerPage = 10;
    TableData source =
        TableData(currentIndex: currentIndex, enabled: enabled, toggle: toggle);
    return PaginatedDataTable(
      source: source,
      columns: COwner.columns.map((column) {
        return DataColumn(
          onSort: (columnIndex, ascending) {
            sort<num>(
                (Cost cost) => cost.value, columnIndex, ascending, source);
          },
          label: Text(
            column,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      header: Stack(
        children: [
          const Center(
            child: Text(
              "Aufschlüsselung",
              style: TextStyle(color: Colors.black),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  buildAddCostPopup();
                },
              ),
            ],
          ),
        ],
      ),
      rowsPerPage: rowsPerPage,
      horizontalMargin: 10,
      showCheckboxColumn: false,
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
    );
  }

  static buildAddCostPopup() {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController datum = TextEditingController();
    TextEditingController grund = TextEditingController();
    TextEditingController summe = TextEditingController();
    String? gewaehlteArt = COwner.arten[0];

    return Get.defaultDialog(
        title: "Kosten Hinzufügen",
        titleStyle: const TextStyle(color: Colors.black),
        content: SizedBox(
          height: 200,
          width: 300,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: datum,
                  cursorColor: const Color(0xff7434E6),
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Datum",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff7434E6)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField(
                      focusColor: Colors.transparent,
                      style: const TextStyle(color: Colors.black),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                      decoration: const InputDecoration(
                        focusColor: Colors.grey,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff7434E6)),
                        ),
                      ),
                      value: gewaehlteArt,
                      items: COwner.arten
                          .map((art) => DropdownMenuItem(
                                value: art,
                                child: Text(
                                  art,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ))
                          .toList(),
                      onChanged: (item) {
                        gewaehlteArt = item;
                      }),
                ),
                TextFormField(
                  cursorColor: const Color(0xff7434E6),
                  style: const TextStyle(color: Colors.black),
                  controller: grund,
                  decoration: const InputDecoration(
                    hintText: "Grund",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff7434E6)),
                    ),
                  ),
                ),
                TextFormField(
                  cursorColor: const Color(0xff7434E6),
                  style: const TextStyle(color: Colors.black),
                  controller: summe,
                  decoration: const InputDecoration(
                    hintText: "Summe",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff7434E6)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomBuilder.customButton(
                    onPressed: () {
                      Get.back();
                    },
                    text: "Schließen"),
                const SizedBox(
                  width: 10,
                ),
                CustomBuilder.customButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Get.back();
                      }
                    },
                    text: "Hinzufügen")
              ],
            ),
          )
        ]);
  }

  static Widget detaillsColumn(
      {required BuildContext context,
      required bool budget,
      required bool enabled,
      Function? toggle}) {
    DateTime? dateTime;
    TextEditingController cost = TextEditingController(text: "23423");
    InputDecoration decoration = const InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text(
                  budget ? "Budget" : "18.12.2001",
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                ),
                const SizedBox(
                  width: 30,
                ),
                budget
                    ? Container()
                    : IconButton(
                        onPressed: () {
                          toggle!();
                        },
                        icon: const Icon(Icons.edit)),
                budget
                    ? Container()
                    : IconButton(
                        onPressed: () {
                          showDatePicker(
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: Color(0xff7434E6),
                                          onPrimary: Colors.white,
                                          onSurface: Colors.white,
                                        ),
                                        dialogBackgroundColor: Colors.black,
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                const Color(0xff7434E6),
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                  cancelText: "ABBRECHEN",
                                  context: context,
                                  initialDate: dateTime ?? DateTime.now(),
                                  firstDate: DateTime(2022),
                                  lastDate: DateTime.now())
                              .then((date) {
                            if (date != null) {}
                          });
                        },
                        icon: const Icon(Icons.calendar_month)),
              ],
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "18.12.2001",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: COwner.arten.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Row(
                      children: [
                        Text("${COwner.arten[index]}: ",
                            style: const TextStyle(color: Colors.black)),
                        Flexible(
                          child: TextField(
                            enabled: enabled && !budget,
                            controller: cost,
                            decoration: decoration,
                            style: TextStyle(
                                color: enabled && !budget
                                    ? const Color(0xff7434E6)
                                    : Colors.black),
                          ),
                        )
                      ],
                    ),
                    iconColor: const Color(0xff7434E6),
                    collapsedIconColor: Colors.black,
                    controlAffinity: ListTileControlAffinity.leading,
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return const Text('Detaills',
                                style: TextStyle(color: Colors.black));
                          })
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
