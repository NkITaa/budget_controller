import 'package:budget_controller/src/pages/owner/controller_owner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../widget_builder.dart';
import 'table.dart';
import '../const_owner.dart';
import '../../../modells/cost.dart';
import 'detaills.dart';

class OwnerBuilder {
  static List<Cost> costs = [
    Cost(
        creation: DateTime.now(),
        category: "Garage",
        value: 342,
        reason: "123455678901234567890",
        description: "123455678901234567890",
        responsibility: "123455678901234567890"),
    Cost(
        creation: DateTime.now(),
        category: "Garage",
        value: 10,
        reason: "Nahrung",
        description: "Wasserkocher",
        responsibility: "Reichert")
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

  static Widget buildTable(
      {required List<String> cells,
      required bool enabled,
      required bool sortAscending,
      required int sortColumnIndex,
      required int currentIndex,
      required Function toggle,
      required Function state,
      required Function sort,
      required BuildContext context}) {
    int rowsPerPage = 10;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TableData source = TableData(
        formKey: formKey,
        currentIndex: currentIndex,
        enabled: enabled,
        toggle: toggle,
        context: context);
    return Form(
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ScaffoldMessenger(
                                child: Builder(
                                  builder: (context) => Scaffold(
                                    backgroundColor: Colors.transparent,
                                    body: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => Navigator.of(context).pop(),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: buildAddCostPopup(
                                            context: context, state: state),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
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
    );
  }

  static buildAddCostPopup(
      {required BuildContext context, required Function state}) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    DateTime? dateTime;
    bool? dateExists;
    TextEditingController reason = TextEditingController();
    TextEditingController description = TextEditingController();
    TextEditingController sum = TextEditingController();
    String gewaehlteArt = COwner.arten[0];

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        state({required String art}) {
          gewaehlteArt = art;
          setState(() {});
        }

        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Ausgabe Hinzufügen",
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
                                customDatePicker(
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
                                arten: COwner.arten,
                                gewaehlteArt: gewaehlteArt,
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
                        controller: sum,
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
                        },
                        text: COwner.close),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomBuilder.customButton(
                        onPressed: () {
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
                            reason.text = "";
                            description.text = "";
                            sum.text = "";
                            gewaehlteArt = COwner.arten[0];
                            dateTime = null;
                            dateExists = null;
                            ScaffoldMessenger.of(context).showSnackBar(
                                CustomBuilder.customSnackBarObject(
                                    message: "Ausgabe Hinzugefügt",
                                    error: false));
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

  static Future<DateTime?> customDatePicker(
      {required BuildContext context, required DateTime? dateTime}) {
    return showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xff7434E6),
                onPrimary: Colors.white,
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: Colors.black,
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xff7434E6),
                ),
              ),
            ),
            child: child!,
          );
        },
        cancelText: COwner.abort,
        context: context,
        initialDate: dateTime ?? DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime.now());
  }

  static Widget detaillsColumn({
    required BuildContext context,
    required bool budget,
  }) {
    bool enabled = false;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    DateTime? dateTime;
    List<TextEditingController> costs = [
      TextEditingController(text: "23432"),
      TextEditingController(text: "23432"),
      TextEditingController(text: "23432")
    ];
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
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
                                enabled = !enabled;
                                setState(() {});
                              }
                            },
                            icon: const Icon(Icons.bar_chart_outlined)),
                    budget
                        ? Container()
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
                                      initialDate: dateTime ?? DateTime.now(),
                                      firstDate: DateTime(2022),
                                      lastDate: DateTime.now())
                                  .then((date) {
                                if (date != null) {
                                  dateTime = date;
                                  setState(() {});
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
                      dateTime?.year.toString() ?? "18.12.2001",
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: COwner.arten.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        title: Row(
                          children: [
                            Text("${COwner.arten[index]}: ",
                                style: const TextStyle(color: Colors.black)),
                            Flexible(
                                child: customTextFormFieldNoDeco(
                                    enabled: enabled,
                                    additionalRequirement: !budget,
                                    controller: costs[index],
                                    isSumme: true))
                          ],
                        ),
                        iconColor: const Color(0xff7434E6),
                        collapsedIconColor: Colors.black,
                        controlAffinity: ListTileControlAffinity.leading,
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return const Text('Detaills',
                                    style: TextStyle(color: Colors.black));
                              })
                        ],
                      );
                    }),
              ],
            );
          }),
        ),
      ),
    );
  }

  static Widget customTextFormFieldNoDeco(
      {required bool enabled,
      required bool additionalRequirement,
      required TextEditingController controller,
      bool? isSumme}) {
    bool summe = isSumme ?? false;
    return TextFormField(
      inputFormatters: [
        summe
            ? FilteringTextInputFormatter.allow(RegExp("[0-9,. €]"))
            : FilteringTextInputFormatter.allow(
                RegExp("[0-9a-zA-Z &üöäßÜÖÄ@€.-]"))
      ],
      validator: (value) {
        return summe
            ? (value!.length < 2 ||
                    double.parse(value.replaceAll("€", "")) < 0.01
                ? ""
                : null)
            : (value!.length < 3 ? "" : null);
      },
      onChanged: (item) {
        if (summe) {
          TextSelection previousSelection = controller.selection;
          controller.text = ControllerOwner.formatInput(item: item);
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
