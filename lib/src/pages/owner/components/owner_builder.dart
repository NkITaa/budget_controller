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

class OwnerBuilder {
  static Widget buildComparison(
      {required double isPrice,
      List<Cost>? costs,
      DateTime? until,
      List<Budget>? budgets,
      required double shouldPrice,
      required bool redirect,
      BuildContext? context,
      List<double>? totalBudgets,
      List<double>? totalCosts}) {
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

  static Widget buildTable(
      {required bool enabled,
      required List<Cost>? costs,
      required bool sortAscending,
      required int sortColumnIndex,
      required int currentIndex,
      required String projectId,
      required Function toggle,
      required Function state,
      required Function sort,
      required BuildContext context,
      required ProjectController projectController}) {
    int rowsPerPage = 10;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TableData source = TableData(
        projectId: projectId,
        projectController: projectController,
        costs: costs,
        formKey: formKey,
        currentIndex: currentIndex,
        enabled: enabled,
        toggle: toggle,
        context: context);
    return SizedBox(
      width: 1300,
      child: Form(
        key: formKey,
        child: PaginatedDataTable(
          source: source,
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
                  StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {
                        return IconButton(
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
                        );
                      }),
                ],
              ),
            ],
          ),
          columns: COwner.columns.map((column) {
            int index = COwner.columns.indexOf(column);
            return DataColumn(
              onSort: (columnIndex, ascending) {
                ControllerOwner.specificSort(
                    index: index,
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
          rowsPerPage: rowsPerPage,
          showCheckboxColumn: false,
          sortColumnIndex: sortColumnIndex,
          sortAscending: sortAscending,
        ),
      ),
    );
  }

  static deleteWarning(
      {required ProjectController projectController,
      required Cost cost,
      required String projectId,
      required Function toggle,
      required int index}) {
    Get.defaultDialog(
        backgroundColor: const Color(0xff7434E6),
        actions: [
          CustomBuilder.customButton(
              text: "Ja",
              onPressed: () async {
                await projectController.deleteCost(
                    projectId: projectId, cost: cost);
                toggle(index: index);
                Get.back();
              }),
          CustomBuilder.customButton(
              isDarkMode: true,
              text: "Nein",
              onPressed: () {
                Get.back();
              })
        ],
        content: Column(children: [
          CustomBuilder.customLogo(size: 50),
          const SizedBox(
            height: 10,
          ),
          const Text(COwner.deleteWarning)
        ]),
        title: "",
        titlePadding: EdgeInsets.zero,
        titleStyle: const TextStyle(fontSize: 0));
  }

  static buildAddCostPopup(
      {required String projectId,
      required Function state2,
      required ProjectController projectController}) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    DateTime? dateTime;
    bool? dateExists;
    TextEditingController reason = TextEditingController();
    TextEditingController description = TextEditingController();
    TextEditingController value = TextEditingController();
    String category = Const.costTypes[0];

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        state({required String art}) {
          category = art;
          setState(() {});
        }

        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              COwner.addCost,
              style: TextStyle(color: Colors.black),
            ),
            content: SizedBox(
              height: 200,
              width: 300,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                                  dateTime: dateTime,
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
                                arten: Const.costTypes,
                                gewaehlteArt: category,
                                setArt: state),
                          )
                        ],
                      ),
                      CustomBuilder.popUpTextField(
                        controller: description,
                        hint: COwner.costAttributes[0],
                      ),
                      CustomBuilder.popUpTextField(
                        controller: reason,
                        hint: COwner.costAttributes[1],
                      ),
                      CustomBuilder.popUpTextField(
                        isSumme: true,
                        controller: value,
                        hint: COwner.costAttributes[2],
                      ),
                    ],
                  ),
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
            ]);
      },
    );
  }

  static Widget detaillsColumn({
    required Function updateExpanded,
    Function? setEnabled,
    Function? setIsPrice,
    Function? updateCostsController,
    required List<TextEditingController> textController,
    required List<Cost>? costs,
    required BuildContext context,
    bool? enabled,
    required bool budget,
    DateTime? costDeadline,
    DateTime? until,
    required List<bool> expanded,
  }) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Padding(
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
                              showDatePicker(
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                              primary: Color(0xff7434E6),
                                              onPrimary: Colors.white,
                                              onSurface: Colors.white,
                                            ),
                                            dialogBackgroundColor: Colors.black,
                                            textButtonTheme:
                                                TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    const Color(0xff7434E6),
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                      cancelText: COwner.abort,
                                      context: context,
                                      initialDate:
                                          costDeadline ?? DateTime.now(),
                                      firstDate: DateTime(2022),
                                      lastDate: DateTime.now())
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
                                child: customTextFormFieldNoDeco(
                                    isNullAllowed: true,
                                    enabled: enabled ?? false,
                                    additionalRequirement: !budget,
                                    controller: textController[index],
                                    isSumme: true))
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

  static Widget customTextFormFieldNoDeco(
      {required bool enabled,
      required bool additionalRequirement,
      required TextEditingController controller,
      bool? isSumme,
      bool? isNullAllowed}) {
    bool summe = isSumme ?? false;
    bool nullAllowed = isNullAllowed ?? false;
    return TextFormField(
      inputFormatters: [
        summe
            ? FilteringTextInputFormatter.allow(RegExp(Const.numInput))
            : FilteringTextInputFormatter.allow(RegExp(Const.basicInput))
      ],
      validator: (value) {
        return summe
            ? (value!.length < 2 || nullAllowed
                ? null
                : double.parse(value.replaceAll(Const.currency, "")) < 0.01
                    ? ""
                    : null)
            : (value!.length < 3 ? "" : null);
      },
      onChanged: (item) {
        if (summe) {
          TextSelection previousSelection = controller.selection;
          controller.text = FormatController.formatInput(item: item);
          controller.selection = previousSelection;
        }
      },
      enabled: enabled && additionalRequirement,
      maxLength: 20,
      controller: controller,
      cursorColor: const Color(0xff7434E6),
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
