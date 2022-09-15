import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    required Function toggle,
    required Function sort,
  }) {
    int rowsPerPage = 10;
    TableData source = TableData(enabled: enabled, toggle: toggle);
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
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
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
}
