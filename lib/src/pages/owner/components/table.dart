import 'package:budget_controller/src/const.dart';
import 'package:budget_controller/src/controller/project_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../controller/format_controller.dart';
import '../../../modells/cost.dart';
import '../../../widget_builder.dart';
import 'owner_builder.dart';

// Defines the Table that is shown in the Owner UI
class TableData extends DataTableSource {
  TableData({
    required this.formKey,
    required this.costs,
    required this.editedRow,
    required this.enabled,
    required this.toggle,
    required this.projectId,
    required this.projectController,
  });

  // Gets Access to all methods of the Project Controller
  final ProjectController projectController;

  // Enables Checking if all values in Form fulfill the requirements
  final GlobalKey<FormState> formKey;

  // informs whether the editing Button in the Table was pressed
  final bool enabled;

  // holds value of row that is edited
  final int editedRow;

  // holds the project ID
  final String projectId;

  // holds a List of all the costs
  final List<Cost>? costs;

  // is the Owner classes toggle Function
  final Function toggle;

  /// method that handles the sort functionality in the table
  ///
  /// * Darts sort method is called
  /// * depending on bool ascending the table is sorted ascending or descending
  sortMe<T>(Comparable<T> Function(Cost cost) getField, bool ascending) {
    return costs?.sort((a, b) {
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
  }

  // Custom Table Row is created
  @override
  DataRow getRow(int index) {
    // specific cost is gotten by index
    Cost cost = costs![index];

    // create Date of cost
    DateTime dateTime = cost.creation;

    // category of cost
    String category = cost.category.toString();

    // reason of cost accrue
    TextEditingController reason =
        TextEditingController(text: cost.reason.toString());

    // value of cost
    TextEditingController value =
        TextEditingController(text: "${cost.value}${Const.currency}");

    // description of cost
    TextEditingController description =
        TextEditingController(text: cost.description.toString());

    // row selected when the edited row equals the build-index
    final bool selectedRow = editedRow == index;

    return DataRow.byIndex(index: index, cells: [
      /// Creation Data Cell
      ///
      /// * row == selected -> DateTimePicker is shown
      /// * row != selected -> TextField with creation Date is shown
      enabled && selectedRow
          ? DataCell(
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Row(
                  children: [
                    Flexible(
                      child: Text(
                        FormatController.dateTimeFormatter(dateTime: dateTime),
                        style: const TextStyle(color: Color(0xff7434E6)),
                      ),
                    ),
                    IconButton(
                        color: const Color(0xff7434E6),
                        onPressed: () {
                          CustomBuilder.customDatePicker(
                                  future: false,
                                  context: context,
                                  chosenDate: dateTime)
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
                FormatController.dateTimeFormatter(dateTime: dateTime),
                style: const TextStyle(color: Colors.black),
              ),
            ),

      /// Category Data Cell
      ///
      /// * row == selected -> Category Dropdown is shown
      /// * row != selected -> Text with selected Cost category is shown
      enabled && selectedRow
          ? DataCell(CustomBuilder.popupDropDown(
              types: Const.costTypes,
              isTable: true,
              chosenType: category,
              setType: ({required String type}) {
                category = type;
              }))
          : DataCell(
              Text(
                category,
                style: const TextStyle(color: Colors.black),
              ),
            ),

      /// Value Data Cell
      ///
      /// * row == selected -> Cost TextField is enabled
      /// * row != selected -> Cost TextField is disabled
      DataCell(OwnerBuilder.textFormFieldNoDeco(
          enabled: enabled,
          additionalRequirement: selectedRow,
          controller: value,
          isNum: true)),

      /// Description Data Cell
      ///
      /// * row == selected -> Description TextField is enabled
      /// * row != selected -> Description TextField is disabled
      DataCell(OwnerBuilder.textFormFieldNoDeco(
          enabled: enabled,
          additionalRequirement: selectedRow,
          controller: description)),

      /// Reason Data Cell
      ///
      /// * row == selected -> Reason TextField is enabled
      /// * row != selected -> Reason TextField is disabled
      DataCell(OwnerBuilder.textFormFieldNoDeco(
          enabled: enabled,
          additionalRequirement: selectedRow,
          controller: reason)),

      /// Actions Data Cell
      ///
      /// * row == selected -> Save & Delete Icon is shown
      /// * row != selected -> Edit Icon is shown
      DataCell(
        enabled && selectedRow
            ? Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.save_outlined,
                        color: Color(0xff7434E6)),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await projectController.updateCost(
                          projectId: projectId,
                          costOld: cost,
                          costNew: Cost(
                              creation: dateTime,
                              category: category,
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
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        color:
                            enabled && selectedRow ? Colors.red : Colors.black,
                      ),
                      onPressed: () {
                        OwnerBuilder.deleteWarning(
                            projectController: projectController,
                            cost: cost,
                            projectId: projectId,
                            toggle: toggle,
                            index: index);
                      })
                ],
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
      ),
    ]);
  }

  /// defaultly overwritten Methods in interface
  ///
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => costs?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
