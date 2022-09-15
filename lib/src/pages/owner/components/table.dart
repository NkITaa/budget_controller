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

    InputDecoration decoration = const InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
    );
    return DataRow.byIndex(index: index, cells: [
      DataCell(TextField(
        enabled: enabled,
        controller: creation,
        decoration: decoration,
        style:
            TextStyle(color: enabled ? const Color(0xff7434E6) : Colors.black),
      )),
      DataCell(TextField(
        enabled: enabled,
        controller: name,
        decoration: decoration,
        style:
            TextStyle(color: enabled ? const Color(0xff7434E6) : Colors.black),
      )),
      DataCell(TextField(
        enabled: enabled,
        controller: type,
        decoration: decoration,
        style:
            TextStyle(color: enabled ? const Color(0xff7434E6) : Colors.black),
      )),
      DataCell(TextField(
        enabled: enabled,
        controller: value,
        decoration: decoration,
        style:
            TextStyle(color: enabled ? const Color(0xff7434E6) : Colors.black),
      )),
      DataCell(TextField(
        enabled: enabled,
        controller: responsibility,
        decoration: decoration,
        style:
            TextStyle(color: enabled ? const Color(0xff7434E6) : Colors.black),
      )),
      DataCell(
        IconButton(
          icon: Icon(
            Icons.edit,
            color: enabled ? const Color(0xff7434E6) : Colors.black,
          ),
          onPressed: () {
            toggle();
          },
        ),
      ),
    ]);
  }
}
