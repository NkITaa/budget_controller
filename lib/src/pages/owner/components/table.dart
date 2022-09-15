import 'package:flutter/material.dart';
import '../../../modells/cost.dart';
import 'owner_builder.dart';

class TableData extends DataTableSource {
  TableData({required this.enabled, required this.toggle});
  final bool enabled;
  final Function toggle;

  sortMe<T>(Comparable<T> Function(Cost cost) getField, bool ascending) {
    return OwnerBuilder.costs.sort((a, b) {
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
  int get rowCount => OwnerBuilder.costs.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    TextEditingController creation = TextEditingController(
        text: OwnerBuilder.costs[index].creation.toString());
    TextEditingController name =
        TextEditingController(text: OwnerBuilder.costs[index].name.toString());
    TextEditingController type =
        TextEditingController(text: OwnerBuilder.costs[index].type.toString());
    TextEditingController value =
        TextEditingController(text: OwnerBuilder.costs[index].value.toString());
    TextEditingController responsibility = TextEditingController(
        text: OwnerBuilder.costs[index].responsibility.toString());
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
