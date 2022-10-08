import 'package:budget_controller/src/controller/project_controller.dart';
import 'package:budget_controller/src/modells/budget.dart';
import 'package:budget_controller/src/pages/owner/controller_owner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../const.dart';
import '../../../controller/format_controller.dart';
import '../../../widget_builder.dart';
import 'table.dart';
import '../const_owner.dart';
import '../../../modells/cost.dart';
import 'detaills.dart';

// Defines Widget Pieces that are used across the Owner UI
class OwnerBuilder {
  static Widget buildComparison({
    required double isPrice,
    required double shouldPrice,
    required bool redirect,
    BuildContext? context,
    List<double>? totalBudgets,
    List<double>? totalCosts,
    List<Budget>? budgets,
    DateTime? until,
    List<Cost>? costs,
  }) {
    // tells whether the costs are critically high
    bool critical = false;

    // sets the critical bool when a percentile is exceeded
    isPrice / shouldPrice > COwner.criticalPercentile
        ? critical = true
        : critical = false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Column that depicts the is-Costs
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
              child: Text("${isPrice.toStringAsFixed(2)}${Const.currency}",
                  style: TextStyle(
                      color: critical ? Colors.red : Colors.green,
                      fontSize: 22)),
            )
          ],
        ),
        const SizedBox(
          width: 50,
        ),

        // Column that depicts the budgets-Costs
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
              child: Text("${shouldPrice.toStringAsFixed(2)}${Const.currency}",
                  style: const TextStyle(color: Colors.black, fontSize: 22)),
            )
          ],
        ),

        // Info-Icon that redirects to the Detaills Screen
        redirect
            ? IconButton(
                icon: const Icon(Icons.info_outline),
                color: const Color(0xff7434E6),
                iconSize: 30,
                onPressed: () => Navigator.push(
                    context!,
                    MaterialPageRoute(
                        builder: (context) => Detaills(
                              totalBudgets: totalBudgets!,
                              totalCosts: totalCosts!,
                              until: until!,
                              costs: costs,
                              budgets: budgets,
                            ))),
              )
            : Container(),
      ],
    );
  }

  // returns Widget that makes up the entire table
  static Widget buildTable(
      {required bool enabled,
      required List<Cost>? costs,
      required bool sortAscending,
      required int sortColumnIndex,
      required int editedRow,
      required String projectId,
      required Function toggle,
      required Function state,
      required Function sort,
      required ProjectController projectController,
      required BuildContext context}) {
    // defines max num of rows that can be depicted on one table page
    int rowsPerPage = 10;

    // formKey that validates the input that is altered in row
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Object that holds the Table Contents
    TableData source = TableData(
      projectId: projectId,
      projectController: projectController,
      costs: costs,
      formKey: formKey,
      editedRow: editedRow,
      enabled: enabled,
      toggle: toggle,
    );
    return SizedBox(
      width: 1300,
      child: Form(
        key: formKey,
        child: PaginatedDataTable(
          source: source,
          rowsPerPage: rowsPerPage,
          showCheckboxColumn: false,
          sortColumnIndex: sortColumnIndex,
          sortAscending: sortAscending,

          /// Header of Table, consists of:
          ///
          /// * Title
          /// * Add Icon, that enables the adding of additional costs
          header: Stack(
            children: [
              const Center(
                child: Text(
                  COwner.details,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      CustomBuilder.createSubscaffold(
                        context: context,
                        child: buildAddCostPopup(
                            projectId: projectId,
                            projectController: projectController,
                            state2: state),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          /// Column
          ///
          /// * on sort a function gets executed, that sorts the specific Column
          /// * depicts a specific label in each Column
          columns: COwner.columns.map((column) {
            return DataColumn(
              onSort: (columnIndex, ascending) {
                ControllerOwner.specificSort(
                    columnIndex: columnIndex,
                    ascending: ascending,
                    source: source,
                    sort: sort);
              },
              label: Text(
                column,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Warning PopUp
  static deleteWarning(
      {required ProjectController projectController,
      required Cost cost,
      required String projectId,
      required Function toggle,
      required int index}) {
    Get.defaultDialog(

        // Content that is depicted inside of the box
        content: Column(children: [
          CustomBuilder.customLogo(size: 50),
          const SizedBox(
            height: 10,
          ),
          const Text(COwner.deleteWarning)
        ]),

        /// Buttons that are depicted under the content
        ///
        /// * on yes -> the delete Function is executed
        /// * on no -> the dialog gets closed
        actions: [
          CustomBuilder.customButton(
              text: Const.yes,
              onPressed: () async {
                await projectController.deleteCost(
                    projectId: projectId, cost: cost);
                projectController.costs?.remove(cost);
                toggle(index: index);
                Get.back();
              }),
          CustomBuilder.customButton(
              isDarkMode: true,
              text: Const.no,
              onPressed: () {
                Get.back();
              })
        ],

        // Styling
        backgroundColor: const Color(0xff7434E6),
        title: "",
        titlePadding: EdgeInsets.zero,
        titleStyle: const TextStyle(fontSize: 0));
  }

  // returns the PopUp where costs can be added
  static buildAddCostPopup(
      {required String projectId,
      required Function state2,
      required ProjectController projectController}) {
    // formKey that validates the input that is altered in row
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // holds the value of specific date when a cost has been created
    DateTime? dateTime;

    // checks whether the compulsory date is defined
    bool? dateExists;

    // TextEditingController that contains the costs-reason
    TextEditingController reason = TextEditingController();

    // TextEditingController that contains the costs-description
    TextEditingController description = TextEditingController();

    // TextEditingController that contains the costs-value
    TextEditingController value = TextEditingController();

    // Sets the default value of DropDown that contains all the categories
    String category = Const.costTypes[0];

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        /// Sets Category
        ///
        /// * On DropDown selection the new category gets assigned
        /// * after that the state in the StatefulBuilder gets called
        state({required String type}) {
          category = type;
          setState(() {});
        }

        return AlertDialog(
          /// Content of the AlertDialog
          content: SizedBox(
            height: 200,
            width: 300,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// upper Row of Content, containing:
                    ///
                    /// * DatePicker, where a cost date gets picked
                    /// * DropDown, where the CostCategory gets selected
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () {
                              CustomBuilder.customDatePicker(
                                future: false,
                                context: context,
                                chosenDate: dateTime,
                              ).then((date) {
                                if (date != null) {
                                  dateTime = date;
                                  dateExists = true;
                                  setState(() {});
                                }
                              });
                            },
                            icon: Icon(
                              Icons.calendar_month,
                              color: (dateExists ?? true)
                                  ? dateTime != null
                                      ? const Color(0xff7434E6)
                                      : Colors.black
                                  : Colors.red,
                            )),
                        const SizedBox(
                          width: 40,
                        ),
                        SizedBox(
                          width: 200,
                          child: CustomBuilder.popupDropDown(
                              types: Const.costTypes,
                              chosenType: category,
                              setType: state),
                        )
                      ],
                    ),

                    /// TextFields, for:
                    ///
                    /// * Entering of Cost-Description
                    /// * Entering of Cost-Reason
                    /// * Entering of Cost-Value
                    CustomBuilder.defaultTextField(
                      controller: description,
                      hint: COwner.costAttributes[0],
                    ),
                    CustomBuilder.defaultTextField(
                      controller: reason,
                      hint: COwner.costAttributes[1],
                    ),
                    CustomBuilder.defaultTextField(
                      isNum: true,
                      controller: value,
                      hint: COwner.costAttributes[2],
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Actions Section, with
          ///
          /// * Get Back Button -> PopUp is closed
          /// * Submit Button
          ///     * Input Validated -> Cost is added to Project
          ///     * Input Invalid -> User Gets Feedback & Cost is not added to Project
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomBuilder.customButton(
                      onPressed: () {
                        Get.back();
                        state2();
                      },
                      text: COwner.close),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomBuilder.customButton(
                      onPressed: ([bool mounted = true]) async {
                        if (dateTime == null) {
                          dateExists = false;
                          setState(() {});
                        }
                        if (dateTime != null) {
                          dateExists = true;
                          setState(() {});
                        }
                        if (formKey.currentState!.validate() &&
                            dateTime != null) {
                          await projectController.addCost(
                            projectId: projectId,
                            cost: Cost(
                                creation: dateTime!,
                                category: category,
                                value: double.parse(value.text
                                    .trim()
                                    .replaceFirst(Const.currency, "")),
                                reason: reason.text.trim(),
                                description: description.text.trim(),
                                responsibility:
                                    FirebaseAuth.instance.currentUser!.uid),
                          );
                          reason.text = "";
                          description.text = "";
                          value.text = "";
                          category = Const.costTypes[0];
                          dateTime = null;
                          dateExists = null;
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                              CustomBuilder.customSnackBarObject(
                                  message: COwner.addedCost, error: false));
                          setState(() {});
                        }
                      },
                      text: COwner.add)
                ],
              ),
            )
          ],

          // Basic Styling
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            COwner.addCost,
            style: TextStyle(color: Colors.black),
          ),
        );
      },
    );
  }

  // Builds a Column with cost/budgets Listings in Detaillsscreen
  static Widget detaillsColumn({
    required Function updateExpanded,
    required List<TextEditingController> textController,
    required List<Cost>? costs,
    required BuildContext context,
    required bool budget,
    required List<bool> expanded,
    Function? updateCostsController,
    DateTime? until,
    DateTime? costDeadline,
    Function? setIsPrice,
    bool? enabled,
    Function? setEnabled,
  }) {
    // formKey that validates the input that is altered
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: Column(
              children: [
                /// Header of the Detaills Sections, depending on value of bool "budget", different Views are shown
                ///
                /// * budget == true -> Only a Title is shown with due date of Budget
                /// * budget == false -> Title is shown with the due date of the budget & additionally 2 IconButtons are depicted
                ///             1. Icon ->  bar_chart_outlined: Enables editing of CostSums, so that forecasts are possible
                ///             2. Icon ->  calendar_month: Enables input of date, which removes all costs after this date from Forecast
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      budget ? COwner.budget : COwner.costs,
                      style: const TextStyle(color: Colors.black, fontSize: 25),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    budget
                        ? Container()
                        : IconButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (enabled!) {
                                  List<double> projections = textController.map(
                                    (e) {
                                      return double.parse(e.text
                                          .trim()
                                          .replaceAll(Const.currency, ""));
                                    },
                                  ).toList();
                                  setIsPrice!(
                                      isPrice: projections.fold<double>(
                                          0, (a, b) => (a) + b));
                                }
                                setEnabled!(enabled: !enabled);
                              }
                            },
                            icon: const Icon(Icons.bar_chart_outlined)),
                    budget
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.calendar_month,
                              color: Colors.transparent,
                            ))
                        : IconButton(
                            onPressed: () {
                              CustomBuilder.customDatePicker(
                                      context: context,
                                      chosenDate: costDeadline,
                                      future: false)
                                  .then((date) {
                                if (date != null) {
                                  updateCostsController!(dateTime: date);
                                }
                              });
                            },
                            icon: const Icon(Icons.calendar_month)),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      FormatController.dateTimeFormatter(
                          dateTime:
                              budget ? until! : costDeadline ?? DateTime.now()),
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),

                /// Body of Detaills Section
                ///
                /// * budget == true -> Budget values is shown; Editing of Forecats is defaultly disabled
                /// * budget == false -> Cost values is shown; Editing of Forecats is enabled when pressed on enable button
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: Const.costTypes.length,
                    itemBuilder: (context, index) {
                      List<Cost?>? costType = FormatController.relevantCosts(
                          costs: costs,
                          category: Const.costTypes[index],
                          date: costDeadline ?? DateTime.now());
                      return ExpansionTile(
                        initiallyExpanded: expanded[index],
                        onExpansionChanged: (value) {
                          updateExpanded(state: value, index: index);
                        },
                        title: Row(
                          children: [
                            Text("${Const.costTypes[index]}: ",
                                style: const TextStyle(color: Colors.black)),
                            Flexible(
                                child: textFormFieldNoDeco(
                                    isNullAllowed: true,
                                    enabled: enabled ?? false,
                                    additionalRequirement: !budget,
                                    controller: textController[index],
                                    isNum: true))
                          ],
                        ),
                        iconColor: const Color(0xff7434E6),
                        collapsedIconColor: Colors.black,
                        controlAffinity: ListTileControlAffinity.leading,
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: costType?.length ?? 0,
                              itemBuilder: (context, index) {
                                return Text(
                                    "${costType![index]!.description}${costType[index]!.value}${Const.currency}",
                                    style: TextStyle(
                                        color: budget
                                            ? Colors.transparent
                                            : Colors.black));
                              })
                        ],
                      );
                    }),
              ],
            )),
      ),
    );
  }

  // returns textFormField that looks like a usual Text Widget when not enabled
  static Widget textFormFieldNoDeco(
      {required bool enabled,
      required bool additionalRequirement,
      required TextEditingController controller,
      bool? isNum,
      bool? isNullAllowed}) {
    /// Assigns bools in Constructor to new Variable
    ///
    /// * when the bool is defined it is set to the Constructors value
    /// * when the bool is undefined it is set to false
    bool num = isNum ?? false;
    bool nullAllowed = isNullAllowed ?? false;

    return TextFormField(
      // Allows different input, depending on if the input is a num or not
      inputFormatters: [
        num
            ? FilteringTextInputFormatter.allow(RegExp(Const.numInput))
            : FilteringTextInputFormatter.allow(RegExp(Const.basicInput))
      ],
      // Validates Input
      validator: (value) {
        return

            // if the input is a num following conditions apply:
            num
                ? (value!.length < 2 || nullAllowed
                    ? null
                    : double.parse(value.replaceAll(Const.currency, "")) < 0.01
                        ? ""
                        : null)

                // if the input is not a num or user id following conditions apply:
                : (value!.length < 3 ? "" : null);
      },

      // assigns the TextEditingController from the Constructor to the Textfield
      controller: controller,

      // Executes Function after every input
      onChanged: (item) {
        // When a num is entered in the TextField the input is formated accordingly
        if (num) {
          TextSelection previousSelection = controller.selection;
          controller.text = FormatController.formatInput(item: item);
          controller.selection = previousSelection;
        }
      },

      /// Sets TextFields maxLength depending on:
      ///
      /// * if its a num
      /// * or not
      maxLength: num ? 9 : 20,

      // Defines the TextFields Style
      cursorColor: const Color(0xff7434E6),
      enabled: enabled && additionalRequirement,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 0.1),
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
      ),
      style: TextStyle(
          color: enabled && additionalRequirement
              ? const Color(0xff7434E6)
              : Colors.black),
    );
  }
}
