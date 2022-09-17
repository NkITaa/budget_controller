import 'package:budget_controller/main.dart';
import 'package:budget_controller/src/pages/owner/const_owner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    final SnackBar snackBar = SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green);
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Widget customTextFormField({
    required TextEditingController controller,
    required String hint,
    required bool password,
  }) {
    return SizedBox(
      height: 35,
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

  static Widget customDrawer({required String userGroup}) {
    return Drawer(
      backgroundColor: const Color(0xff7434E6),
      child: Column(
        children: [
          Text(userGroup),
          OutlinedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: const Text(COwner.signOut),
          ),
        ],
      ),
    );
  }

  static Widget popUpTextField(
      {required TextEditingController controller,
      required String hint,
      bool? isUid,
      bool? isSumme}) {
    bool summe = isSumme ?? false;
    bool uid = isUid ?? false;
    return TextFormField(
      inputFormatters: [
        summe
            ? FilteringTextInputFormatter.allow(RegExp("[0-9 €]"))
            : FilteringTextInputFormatter.allow(
                RegExp("[0-9a-zA-Z &üöäßÜÖÄ@€.-]"))
      ],
      validator: (value) {
        return uid
            ? (value!.length < 20 ? Const.minUidError : null)
            : (value!.length < 3 ? Const.minThreeCharsError : null);
      },
      cursorColor: const Color(0xff7434E6),
      style: const TextStyle(color: Colors.black),
      controller: controller,
      maxLength: summe ? 9 : 20,
      decoration: InputDecoration(
        hintText: hint,
        counterText: uid ? null : "",
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
}
