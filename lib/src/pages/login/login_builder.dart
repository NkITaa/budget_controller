import 'package:flutter/material.dart';

import '../../const.dart';

class LoginBuilder {
  static Widget textFormField({
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
            helperText: "",
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
}
