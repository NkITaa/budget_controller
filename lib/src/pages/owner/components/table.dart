import 'package:budget_controller/src/pages/owner/controller_owner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../modells/cost.dart';
import '../const_owner.dart';
import 'owner_builder.dart';

class TableData extends DataTableSource {
  TableData(
      {required this.currentIndex,
      required this.enabled,
      required this.toggle,
      required this.context});
  final int currentIndex;
  final bool enabled;
  final Function toggle;
  final BuildContext context;

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
    DateTime? dateTime;
    String gewaehlteArt = COwner.arten[0];

    void setArt({required String art}) {
      gewaehlteArt = art;
    }

    TextEditingController creation = TextEditingController(
        text:
            "${OwnerBuilder.costs[index].creation.day.toString()}/${OwnerBuilder.costs[index].creation.month.toString()}/${OwnerBuilder.costs[index].creation.year.toString()}");

    TextEditingController reason = TextEditingController(
        text: OwnerBuilder.costs[index].reason.toString());

    TextEditingController category = TextEditingController(
        text: OwnerBuilder.costs[index].category.toString());

    TextEditingController value =
        TextEditingController(text: OwnerBuilder.costs[index].value.toString());

    TextEditingController description = TextEditingController(
        text: OwnerBuilder.costs[index].description.toString());

    TextEditingController responsibility = TextEditingController(
        text: OwnerBuilder.costs[index].responsibility.toString());

    InputDecoration decoration = const InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      counterText: "",
    );
    final bool selectedRow = currentIndex == index;
    return DataRow.byIndex(index: index, cells: [
      enabled && selectedRow
          ? DataCell(
              IconButton(
                  color: const Color(0xff7434E6),
                  onPressed: () {
                    OwnerBuilder.customDatePicker(
                            context: context, dateTime: dateTime)
                        .then((date) {
                      if (date != null) {
                        print(date);
                      }
                    });
                  },
                  icon: const Icon(Icons.calendar_month)),
            )
          : DataCell(TextFormField(
              enabled: false,
              controller: creation,
              decoration: decoration,
              maxLength: 10,
              cursorColor: const Color(0xff7434E6),
              style: const TextStyle(color: Colors.black),
            )),
      enabled && selectedRow
          ? DataCell(OwnerBuilder.categoryDropDown(
              table: true, gewaehlteArt: gewaehlteArt, setArt: setArt))
          : DataCell(TextFormField(
              enabled: true,
              controller: category,
              decoration: decoration,
              cursorColor: const Color(0xff7434E6),
              style: const TextStyle(color: Colors.black),
            )),
      DataCell(TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9 .,€]"))
        ],
        onChanged: (item) {
          TextSelection previousSelection = value.selection;

          value.text = ControllerOwner.formatInput(item: item);
          value.selection = previousSelection;
        },
        enabled: enabled && selectedRow,
        controller: value,
        maxLength: 10,
        decoration: decoration,
        cursorColor: const Color(0xff7434E6),
        style: TextStyle(
            color: enabled && selectedRow
                ? const Color(0xff7434E6)
                : Colors.black),
      )),
      DataCell(TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z &üöäßÜÖÄ@€.-]"))
        ],
        enabled: enabled && selectedRow,
        controller: description,
        cursorColor: const Color(0xff7434E6),
        maxLength: 20,
        decoration: decoration,
        style: TextStyle(
            color: enabled && selectedRow
                ? const Color(0xff7434E6)
                : Colors.black),
      )),
      DataCell(TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z &üöäßÜÖÄ@€.-]"))
        ],
        enabled: enabled && selectedRow,
        maxLength: 20,
        controller: reason,
        cursorColor: const Color(0xff7434E6),
        decoration: decoration,
        style: TextStyle(
            color: enabled && selectedRow
                ? const Color(0xff7434E6)
                : Colors.black),
      )),
      DataCell(TextFormField(
        enabled: false,
        controller: responsibility,
        cursorColor: const Color(0xff7434E6),
        decoration: decoration,
        style: const TextStyle(color: Colors.black),
      )),
      DataCell(
        IconButton(
          icon: Icon(
            Icons.edit,
            color:
                enabled && selectedRow ? const Color(0xff7434E6) : Colors.black,
          ),
          onPressed: () {
            toggle(index: index);
          },
        ),
      ),
    ]);
  }
}
