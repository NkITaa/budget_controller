import 'package:animate_icons/animate_icons.dart';
import 'package:budget_controller/main.dart';
import 'package:budget_controller/src/pages/login/component_reset_password.dart';
import 'package:budget_controller/src/pages/manager/components/decision_history.dart';
import 'package:budget_controller/src/pages/owner/const_owner.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'const.dart';
import 'controller/format_controller.dart';
import 'controller/project_controller.dart';

// Defines Widget Pieces that are used across the application
class CustomBuilder {
  // Depiction of Default Progress Indicator
  static void customProgressIndicator({required BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const Center(
              child: CircularProgressIndicator(),
            ));
  }

  // Depiction of SnackBar Object
  static void showSnackBarObject({required SnackBar snackBar}) {
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  // Returns a SnackBar Object
  static SnackBar customSnackBarObject(
      {required String message, required bool error}) {
    /// Creation of SnackBar Object
    ///
    /// * depicts Text from Constructor
    /// * depending on the "error bool" the color is altered
    return SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green);
  }

  // Creates and shows a custom SnackBar Object
  static void customSnackBar({required String message, required bool error}) {
    // Creates SnackBar Object
    SnackBar snackBar = customSnackBarObject(message: message, error: error);

    // Shows SnackBar
    showSnackBarObject(snackBar: snackBar);
  }

  /// Returns a custom Button
  static Widget customButton({
    required String text,
    required void Function() onPressed,
    bool? isDarkMode,
    bool? isLightMode,
  }) {
    /// Assigns bools in Constructor to new Variable
    ///
    /// * when the bool is defined it is set to the Constructors value
    /// * when the bool is undefined it is set to false
    bool darkMode = isDarkMode ?? false;
    bool lightMode = isLightMode ?? false;

    return OutlinedButton(
      // Function of Constructor is assigned to onPressed Property
      onPressed: onPressed,

      /// Sets Button Style
      ///
      /// * when darkmode == true the background color is altered
      /// * when lightMode == true the border color is altered
      style: OutlinedButton.styleFrom(
        backgroundColor: darkMode ? const Color(0xff85CCFF) : Colors.white,
        side: BorderSide(
            color: lightMode ? const Color(0xff7434E6) : Colors.transparent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),

      /// Sets Button Text
      ///
      /// * The depicted text is the value of the text variable in the constructor
      /// * when darkMode == true the text color is altered
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text,
            style: TextStyle(
                color: darkMode ? Colors.white : const Color(0xff7434E6),
                fontSize: 18)),
      ),
    );
  }

  /// Returns a customsized Logo-Image
  ///
  /// * the size property in the constructor defines the logos height & width
  static Widget customLogo({required double size}) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(Const.logoPath),
      )),
    );
  }

  // Returns the Apps default AppBar
  static PreferredSizeWidget customAppBar({required BuildContext context}) {
    return PreferredSize(
      // Wraps the AppBar and gives the Wrapper a height
      preferredSize: const Size.fromHeight(60),

      child: AppBar(
        // defines the AppBars design properties
        toolbarHeight: 50,
        backgroundColor: const Color(0xff7434E6),
        elevation: 0,

        // defines the AppBars Contents
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomBuilder.customLogo(size: 40),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Return the Apps deault Drawer
  static Widget customDrawer(
      {required String userGroup, required BuildContext context}) {
    // Creates an animation Controller in order to animate the Checkmark
    AnimateIconController controller = AnimateIconController();

    return Drawer(
      backgroundColor: const Color(0xff7434E6),

      // Defines the Drawers Contents
      child: Stack(
        children: [
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                /// Drawer Header
                ///
                /// * depicts Logo
                /// * depicts User ID
                const SizedBox(
                  height: 20,
                ),
                customLogo(size: 70),
                Text(
                  userGroup,
                  style: const TextStyle(fontSize: 25),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      FirebaseAuth.instance.currentUser!.uid,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    animateCheckmark(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text: FirebaseAuth.instance.currentUser!.uid));
                          return true;
                        },
                        controller: controller)
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: Colors.white,
                ),

                /// Drawer Body
                ///
                /// * depicts Tile that redirects to the ResetPassword Page
                /// * if userGroup == Manager an Additional Tile that redirects to the Managers Decision History is shown
                ListTile(
                    leading: const Icon(Icons.password),
                    iconColor: Colors.white,
                    title: const Text(Const.changePassword),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPassword()))),
                userGroup == Const.userRoles[0]
                    ? ListTile(
                        leading: const Icon(Icons.book_outlined),
                        iconColor: Colors.white,
                        title: const Text(Const.decisionHistory),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DecisionHistory())))
                    : Container()
              ],
            );
          }),

          /// Drawer Bottom
          ///
          /// * a Logout Button is shown
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: customButton(
                    text: Const.signOut,
                    onPressed: () {
                      signOutWarning();
                    }),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          )
        ],
      ),
    );
  }

  // returns the applications default TextFied
  static Widget defaultTextField(
      {required TextEditingController controller,
      bool? enabled,
      String? hint,
      bool? isMail,
      bool? isUid,
      bool? isNum}) {
    /// Assigns bools in Constructor to new Variable
    ///
    /// * when the bool is defined it is set to the Constructors value
    /// * when the bool is undefined it is set to false
    bool num = isNum ?? false;
    bool uid = isUid ?? false;
    bool mail = isMail ?? false;

    return TextFormField(
      // Allows different input, depending on if the input is a num or not
      inputFormatters: [
        num
            ? FilteringTextInputFormatter.allow(RegExp(Const.numInput))
            : FilteringTextInputFormatter.allow(RegExp(Const.basicInput))
      ],

      validator: (value) {
        // Validates Input
        return

            // if the input is a num following conditions apply:
            num
                ? (value!.length < 2 ||
                        double.parse(value.replaceAll(Const.currency, "")) <
                            0.01
                    ? ""
                    : null)

                // if the input is a user id following conditions apply:
                : uid
                    ? (value!.length < 28 ? "" : null)

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
      /// * if its a mail
      /// * if its a uid
      /// * or nothing of the above
      maxLength: num
          ? 9
          : mail
              ? 50
              : uid
                  ? 28
                  : 20,

      // Defines the TextFields Style
      cursorColor: const Color(0xff7434E6),
      style: const TextStyle(color: Colors.black),
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hint,
        counterText: uid ? null : "",
        errorStyle: const TextStyle(fontSize: 0.1),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xff7434E6)),
        ),
      ),
    );
  }

  // returns the applications default DropDownButton
  static Widget popupDropDown({
    required String? chosenType,
    required List<String>? types,
    required Function setType,
    bool? isTable,
  }) {
    /// Assigns bools in Constructor to new Variable
    ///
    /// * when the bool is defined it is set to the Constructors value
    /// * when the bool is undefined it is set to false
    bool table = isTable ?? false;

    return DropdownButtonFormField(
      // sets the value that is shown in the DropDown-Box
      value: chosenType,

      // adds all types in the selection section of the DropDown
      items: types
          ?.map((art) => DropdownMenuItem(
                value: art,
                child: Text(
                  art,
                  style: TextStyle(
                      color: table ? const Color(0xff7434E6) : Colors.black),
                ),
              ))
          .toList(),

      // updates value when new value is selected
      onChanged: (type) {
        setType(type: type);
      },

      /// sets the Widgets Style
      ///
      /// * Design alters depending on whether the dropdown is in a table or not
      focusColor: Colors.transparent,
      style: const TextStyle(color: Colors.black),
      icon: Icon(
        Icons.arrow_drop_down,
        color: table ? const Color(0xff7434E6) : Colors.grey,
      ),
      decoration: InputDecoration(
        focusColor: table ? Colors.transparent : Colors.grey,
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: table ? Colors.transparent : Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: table ? Colors.transparent : const Color(0xff7434E6)),
        ),
      ),
    );
  }

  // return the applications default Checkmark
  static Widget animateCheckmark(
      {required bool Function() onPressed,
      required AnimateIconController controller,
      bool? isDark}) {
    /// Assigns bools in Constructor to new Variable
    ///
    /// * when the bool is defined it is set to the Constructors value
    /// * when the bool is undefined it is set to false
    bool dark = isDark ?? false;

    // returns a Widget that animates from a copy mark to a checkmark
    return AnimateIcons(
      startIcon: Icons.copy_all_outlined,
      endIcon: Icons.check,
      controller: controller,
      onStartIconPress: onPressed,
      onEndIconPress: onPressed,
      duration: const Duration(milliseconds: 100),
      startIconColor: dark ? Colors.black : Colors.white,
      endIconColor: const Color.fromARGB(255, 0, 255, 8),
      clockwise: false,
    );
  }

  // Calls Function that returns the Applications SignOut Warning Dialog
  static signOutWarning() {
    Get.defaultDialog(

        // Sets the Dialogs Contents
        content: Column(children: [
          customLogo(size: 50),
          const SizedBox(
            height: 10,
          ),
          const Text(Const.approveLogout)
        ]),

        /// Defines the dialog Actions
        ///
        /// * on Yes -> the User is Signed out
        /// * on No -> the Dialog is closed
        actions: [
          customButton(
              text: Const.yes,
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.back();
              }),
          customButton(
              isDarkMode: true,
              text: Const.no,
              onPressed: () {
                Get.back();
              })
        ],

        // Sets Global Dialog design
        backgroundColor: const Color(0xff7434E6),
        title: "",
        titlePadding: EdgeInsets.zero,
        titleStyle: const TextStyle(fontSize: 0));
  }

  // returns a custom date Picker
  static Future<DateTime?> customDatePicker(
      {required BuildContext context,
      required DateTime? chosenDate,
      required bool future}) {
    return showDatePicker(
        builder: (context, child) {
          return

              // the Pickers design is set
              Theme(
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

        /// the Pickers initial date & data ranges are defined from the Constructor
        ///
        /// * when the chosenDate is undefined the inital day is the current date
        /// * depending if the future should be shown only future dates or rather past dates are shown
        initialDate: chosenDate ?? DateTime.now(),
        firstDate: future ? DateTime.now() : DateTime(2022),
        lastDate: future ? DateTime(2030) : DateTime.now());
  }

  // returns a dropDown that also has search functionalities
  static Widget customSearchDropDown({required List<String> items}) {
    // projectController is initialized to access certain methods
    ProjectController projectController = Get.find();

    return DropdownSearch<String>(
      // all constructor items are given to the Widget
      items: items,

      // when the input changes the selected value is assigned to a variable
      onChanged: (currentItem) {
        projectController.owner = currentItem;
      },

      //the input gets validated
      validator: (String? item) {
        // when the owner value is not defined an error is triggered
        if (projectController.owner == null) {
          return "";
        } else {
          return null;
        }
      },

      // style definition of the Widgets dropdown
      dropdownBuilder: (context, selectedItem) {
        return Text(
          projectController.owner ?? Const.chooseOwner,
          style: TextStyle(
            color: projectController.owner == null ? Colors.grey : Colors.black,
          ),
        );
      },

      // style definition of the Widgets menu
      popupProps: PopupProps.menu(
        itemBuilder: (context, item, isSelected) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item,
              style: const TextStyle(color: Colors.black, fontSize: 10),
            ),
          );
        },
        searchFieldProps: const TextFieldProps(
            cursorColor: Color(0xff7434E6),
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: Const.search,
              focusColor: Colors.grey,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff7434E6)),
              ),
            )),
        showSelectedItems: true,
        showSearchBox: true,
      ),

      // general design are designed here
      dropdownButtonProps: const DropdownButtonProps(
        color: Colors.black,
      ),
      dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
        errorStyle: TextStyle(fontSize: 0.1),
        focusColor: Colors.grey,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xff7434E6)),
        ),
      )),
    );
  }

  // creation of a Subscaffold in order to show SnackBars in PopUps
  static createSubscaffold(
      {required BuildContext context, required Widget child}) {
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
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // returns a Widget that is depicted when a Future build execution returns an error
  static Widget defaultFutureError({required String error}) {
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        Text(
          error,
          style: const TextStyle(fontSize: 30, color: Colors.black),
        ),
      ],
    );
  }
}
