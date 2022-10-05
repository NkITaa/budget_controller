import 'package:budget_controller/src/const.dart';
import 'package:budget_controller/src/controller/project_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../controller/format_controller.dart';
import '../../../modells/cost.dart';
import '../../../widget_builder.dart';
import 'owner_builder.dart';

class TableData extends DataTableSource {
  TableData(
      {required this.formKey,
      required this.costs,
      required this.currentIndex,
      required this.enabled,
      required this.toggle,
      required this.projectId,
      required this.projectController,
      required this.context});
  final GlobalKey<FormState> formKey;
  final int currentIndex;
  final String projectId;
  final bool enabled;
  final Function toggle;
  final BuildContext context;
  final ProjectController projectController;
  final List<Cost>? costs;

  sortMe<T>(Comparable<T> Function(Cost cost) getField, bool ascending) {
    return costs?.sort((a, b) {
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
  int get rowCount => costs?.length ?? 0;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    DateTime? dateTime;
    String? category = costs?[index].category.toString();
    TextEditingController reason =
        TextEditingController(text: costs?[index].reason.toString());
    TextEditingController value =
        TextEditingController(text: "${costs?[index].value}${Const.currency}");
    TextEditingController description =
        TextEditingController(text: costs?[index].description.toString());
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
                        FormatController.dateTimeFormatter(
                            dateTime: dateTime ?? costs![index].creation),
                        style: const TextStyle(color: Color(0xff7434E6)),
                      ),
                    ),
                    IconButton(
                        color: const Color(0xff7434E6),
                        onPressed: () {
                          CustomBuilder.customDatePicker(
                                  future: false,
                                  context: context,
                                  dateTime: dateTime)
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
                FormatController.dateTimeFormatter(
                    dateTime: costs![index].creation),
                style: const TextStyle(color: Colors.black),
              ),
            ),
      enabled && selectedRow
          ? DataCell(CustomBuilder.popupDropDown(
              arten: Const.costTypes,
              isTable: true,
              gewaehlteArt: category,
              setArt: ({required String art}) {
                category = art;
              }))
          : DataCell(
              Text(
                category!,
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
        Row(
          children: [
            enabled && selectedRow
                ? IconButton(
                    icon: const Icon(Icons.save_outlined,
                        color: Color(0xff7434E6)),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await projectController.updateCost(
                          projectId: projectId,
                          costOld: costs![index],
                          costNew: Cost(
                              creation: dateTime ?? costs![index].creation,
                              category: category!,
                              value: double.parse(value.text
                                  .trim()
                                  .replaceFirst(Const.currency, "")),
                              reason: reason.text.trim(),
                              description: description.text.trim(),
                              responsibility:
                                  FirebaseAuth.instance.currentUser!.uid),
                        );
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
                    onPressed: () {
                      OwnerBuilder.deleteWarning(
                          projectController: projectController,
                          cost: costs![index],
                          projectId: projectId,
                          toggle: toggle,
                          index: index);
                    })
                : Container(),
          ],
        ),
      ),
    ]);
  }
}
