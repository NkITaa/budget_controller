import 'package:animate_icons/animate_icons.dart';
import 'package:budget_controller/main.dart';
import 'package:budget_controller/src/pages/login/component_reset_password.dart';
import 'package:budget_controller/src/pages/owner/controller_owner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiselect/multiselect.dart';

import 'const.dart';

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

  static Widget customButton(
      {required String text, required void Function() onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.transparent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text,
            style: const TextStyle(color: Color(0xff7434E6), fontSize: 18)),
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
                      FirebaseAuth.instance.signOut();
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
      required String hint,
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
            ? (value!.length < 2 ? "" : null)
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
          controller.text = ControllerOwner.formatInput(item: item);
          controller.selection = previousSelection;
        }
      },
      maxLength: summe
          ? 9
          : mail
              ? 50
              : 28,
      decoration: InputDecoration(
        hintText: hint,
        counterText: uid ? null : "",
        errorStyle: TextStyle(fontSize: 0.1),
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
    required String gewaehlteArt,
    required List<String> arten,
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
            .map((art) => DropdownMenuItem(
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

  static Widget popupDropDownList({
    required List<String>? gewaehlteArten,
    required List<String> arten,
    required Function setArten,
    bool? isTable,
  }) {
    bool table = isTable ?? false;
    return DropDownMultiSelect(
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
        childBuilder: (selectedValues) {
          if (selectedValues.isNotEmpty) {
            return Text(
              selectedValues.reduce((a, b) => '$a , $b'),
              style: const TextStyle(color: Colors.black),
            );
          }
          return const Text("");
        },
        hintStyle: const TextStyle(color: Colors.black),
        selectedValues: gewaehlteArten ?? [],
        whenEmpty: "",
        options: arten,
        onChanged: (List<String> specificArten) {
          setArten(arten: specificArten);
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
}
