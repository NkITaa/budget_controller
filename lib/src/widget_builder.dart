import 'package:budget_controller/main.dart';
import 'package:flutter/material.dart';

import 'Constants/const.dart';

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
    return TextFormField(
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
        fit: BoxFit.fill,
        image: AssetImage("assets/logo.png"),
      )),
    );
  }
}
