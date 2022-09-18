import 'package:budget_controller/src/pages/owner/controller_owner.dart';
import 'package:flutter/material.dart';
import '../../../modells/cost.dart';
import '../../../widget_builder.dart';
import '../const_owner.dart';
import 'owner_builder.dart';

class TableData extends DataTableSource {
  TableData(
      {required this.formKey,
      required this.currentIndex,
      required this.enabled,
      required this.toggle,
      required this.context});
  final GlobalKey<FormState> formKey;
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

    String responsibility = OwnerBuilder.costs[index].responsibility.toString();

    String category = OwnerBuilder.costs[index].category.toString();

    TextEditingController reason = TextEditingController(
        text: OwnerBuilder.costs[index].reason.toString());

    TextEditingController value =
        TextEditingController(text: "${OwnerBuilder.costs[index].value}€");

    TextEditingController description = TextEditingController(
        text: OwnerBuilder.costs[index].description.toString());

    final bool selectedRow = currentIndex == index;
    return DataRow.byIndex(index: index, cells: [
      enabled && selectedRow
          ? DataCell(
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Row(
                  children: [
                    Flexible(
                      child: Text(
                        ControllerOwner.dateTimeFormatter(
                            dateTime:
                                dateTime ?? OwnerBuilder.costs[index].creation),
                        style: const TextStyle(color: Color(0xff7434E6)),
                      ),
                    ),
                    IconButton(
                        color: const Color(0xff7434E6),
                        onPressed: () {
                          OwnerBuilder.customDatePicker(
                                  context: context, dateTime: dateTime)
                              .then((date) {
                            if (date != null) {
                              dateTime = date;
                              setState(() {});
                            }
                          });
                        },
                        icon: const Icon(Icons.calendar_month))
                  ],
                );
              }),
            )
          : DataCell(
              Text(
                ControllerOwner.dateTimeFormatter(
                    dateTime: OwnerBuilder.costs[index].creation),
                style: const TextStyle(color: Colors.black),
              ),
            ),
      enabled && selectedRow
          ? DataCell(CustomBuilder.popupDropDown(
              arten: COwner.arten,
              isTable: true,
              gewaehlteArt: category,
              setArt: ({required String art}) {
                category = art;
              }))
          : DataCell(
              Text(
                category,
                style: const TextStyle(color: Colors.black),
              ),
            ),
      DataCell(OwnerBuilder.customTextFormFieldNoDeco(
          enabled: enabled,
          additionalRequirement: selectedRow,
          controller: value,
          isSumme: true)),
      DataCell(OwnerBuilder.customTextFormFieldNoDeco(
          enabled: enabled,
          additionalRequirement: selectedRow,
          controller: description)),
      DataCell(OwnerBuilder.customTextFormFieldNoDeco(
          enabled: enabled,
          additionalRequirement: selectedRow,
          controller: reason)),
      DataCell(
        Text(
          responsibility,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      DataCell(
        Row(
          children: [
            enabled && selectedRow
                ? IconButton(
                    icon: const Icon(Icons.save_outlined,
                        color: Color(0xff7434E6)),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        toggle(index: index);
                      }
                    },
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      toggle(index: index);
                    },
                  ),
            enabled && selectedRow
                ? IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: enabled && selectedRow ? Colors.red : Colors.black,
                    ),
                    onPressed: () {},
                  )
                : Container(),
          ],
        ),
      ),
    ]);
  }
}
