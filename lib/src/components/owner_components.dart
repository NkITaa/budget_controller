import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/const_owner.dart';
import '../modells/cost.dart';
import '../pages/detaills.dart';

class OwnerComponents {
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

class TableData extends DataTableSource {
  TableData({required this.enabled, required this.toggle});
  final bool enabled;
  final Function toggle;

  sortMe<T>(Comparable<T> Function(Cost cost) getField, bool ascending) {
    return COwner.costs.sort((a, b) {
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => COwner.costs.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    TextEditingController creation =
        TextEditingController(text: COwner.costs[index].creation.toString());
    TextEditingController name =
        TextEditingController(text: COwner.costs[index].name.toString());
    TextEditingController type =
        TextEditingController(text: COwner.costs[index].type.toString());
    TextEditingController value =
        TextEditingController(text: COwner.costs[index].value.toString());
    TextEditingController responsibility = TextEditingController(
        text: COwner.costs[index].responsibility.toString());
    return DataRow.byIndex(index: index, cells: [
      DataCell(TextField(
        enabled: enabled,
        controller: creation,
        style: const TextStyle(color: Colors.black),
      )),
      DataCell(TextField(
        enabled: enabled,
        controller: name,
        style: const TextStyle(color: Colors.black),
      )),
      DataCell(TextField(
        enabled: enabled,
        controller: type,
        style: const TextStyle(color: Colors.black),
      )),
      DataCell(TextField(
        enabled: enabled,
        controller: value,
        style: const TextStyle(color: Colors.black),
      )),
      DataCell(TextField(
        enabled: enabled,
        controller: responsibility,
        style: const TextStyle(color: Colors.black),
      )),
      DataCell(
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            toggle();
          },
        ),
      ),
    ]);
  }
}
