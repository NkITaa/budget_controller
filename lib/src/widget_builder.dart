import 'package:animate_icons/animate_icons.dart';
import 'package:budget_controller/main.dart';
import 'package:budget_controller/src/pages/login/component_reset_password.dart';
import 'package:budget_controller/src/pages/owner/const_owner.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'const.dart';
import 'controller/format_controller.dart';
import 'controller/project_controller.dart';

class CustomBuilder {
  static void customProgressIndicator({required BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const Center(
              child: CircularProgressIndicator(),
            ));
  }

  static void customSnackBar({required String message, required bool error}) {
    SnackBar snackBar = SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green);
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showSnackBarObject({required SnackBar snackBar}) {
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static SnackBar customSnackBarObject(
      {required String message, required bool error}) {
    return SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green);
  }

  static Widget loginTextFormField({
    required TextEditingController controller,
    required String hint,
    bool? isPassword,
  }) {
    bool password = isPassword ?? false;
    return SizedBox(
      height: 60,
      child: TextFormField(
        controller: controller,
        obscureText: password,
        enableSuggestions: false,
        autocorrect: false,
        cursorColor: const Color(0xff7434E6),
        style: const TextStyle(color: Color(0xff7434E6)),
        validator: (value) {
          if (value == "") {
            return password ? Const.nullPasswordError : Const.nullFieldError;
          } else {
            if (value!.length < 6 && password) {
              return Const.lengthError;
            } else {
              return null;
            }
          }
        },
        decoration: InputDecoration(
            helperText: " ",
            contentPadding: const EdgeInsets.only(left: 20),
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[800]),
            hintText: hint,
            fillColor: Colors.white,
            errorStyle: const TextStyle(color: Color(0xffFF4D4D)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(20.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffFF4D4D)),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffFF4D4D)),
              borderRadius: BorderRadius.circular(20.0),
            )),
      ),
    );
  }

  static Widget customButton({
    required String text,
    required void Function() onPressed,
    bool? isDarkMode,
    bool? isLightMode,
  }) {
    bool darkMode = isDarkMode ?? false;
    bool lightMode = isLightMode ?? false;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: darkMode ? const Color(0xff85CCFF) : Colors.white,
        side: BorderSide(
            color: lightMode ? const Color(0xff7434E6) : Colors.transparent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text,
            style: TextStyle(
                color: darkMode ? Colors.white : const Color(0xff7434E6),
                fontSize: 18)),
      ),
    );
  }

  static Widget customLogo({required double size}) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage("assets/logo.png"),
      )),
    );
  }

  static PreferredSizeWidget customAppBar({required BuildContext context}) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        toolbarHeight: 50,
        backgroundColor: const Color(0xff7434E6),
        elevation: 0,
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

  static Widget customDrawer(
      {required String userGroup, required BuildContext context}) {
    AnimateIconController controller = AnimateIconController();
    return Drawer(
      backgroundColor: const Color(0xff7434E6),
      child: Stack(
        children: [
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
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
                ListTile(
                    leading: const Icon(Icons.password),
                    iconColor: Colors.white,
                    title: const Text("Password ändern"),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPassword())))
              ],
            );
          }),
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

  static Widget popUpTextField(
      {required TextEditingController controller,
      bool? enabled,
      String? hint,
      bool? isMail,
      bool? isUid,
      bool? isSumme}) {
    bool summe = isSumme ?? false;
    bool uid = isUid ?? false;
    bool mail = isMail ?? false;
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
            : uid
                ? (value!.length < 28 ? "" : null)
                : (value!.length < 3 ? "" : null);
      },
      cursorColor: const Color(0xff7434E6),
      style: const TextStyle(color: Colors.black),
      controller: controller,
      onChanged: (item) {
        if (summe) {
          TextSelection previousSelection = controller.selection;
          controller.text = FormatController.formatInput(item: item);
          controller.selection = previousSelection;
        }
      },
      enabled: enabled,
      maxLength: summe
          ? 9
          : mail
              ? 50
              : uid
                  ? 28
                  : 20,
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

  static Widget popupDropDown({
    required String? gewaehlteArt,
    required List<String>? arten,
    required Function setArt,
    bool? isTable,
  }) {
    bool table = isTable ?? false;
    return DropdownButtonFormField(
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
        value: gewaehlteArt,
        items: arten
            ?.map((art) => DropdownMenuItem(
                  value: art,
                  child: Text(
                    art,
                    style: TextStyle(
                        color: table ? const Color(0xff7434E6) : Colors.black),
                  ),
                ))
            .toList(),
        onChanged: (art) {
          setArt(art: art);
        });
  }

  static Widget animateCheckmark(
      {required bool Function() onPressed,
      required AnimateIconController controller,
      bool? isDark}) {
    bool dark = isDark ?? false;
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

  static signOutWarning() {
    Get.defaultDialog(
        backgroundColor: const Color(0xff7434E6),
        actions: [
          customButton(
              text: "Ja",
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.back();
              }),
          customButton(
              isDarkMode: true,
              text: "Nein",
              onPressed: () {
                Get.back();
              })
        ],
        content: Column(children: [
          customLogo(size: 50),
          const SizedBox(
            height: 10,
          ),
          const Text("Möchtest du dich wirklich abmelden?")
        ]),
        title: "",
        titlePadding: EdgeInsets.zero,
        titleStyle: const TextStyle(fontSize: 0));
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

  static Widget customSearchDropDown({required List<String> items}) {
    ProjectController projectController = Get.find();
    return DropdownSearch<String>(
      dropdownBuilder: (context, selectedItem) {
        return Text(
          projectController.owner ?? "Owner auswählen",
          style: TextStyle(
            color: projectController.owner == null ? Colors.grey : Colors.black,
          ),
        );
      },
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
              hintText: "Suchen",
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
      items: items,
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
      onChanged: (currentItem) {
        projectController.owner = currentItem;
      },
      validator: (String? item) {
        if (projectController.owner == null) {
          return "";
        } else {
          return null;
        }
      },
    );
  }
}
