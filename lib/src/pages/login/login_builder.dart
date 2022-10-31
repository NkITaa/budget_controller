import 'package:flutter/material.dart';

import '../../const.dart';

// Defines Widget Pieces that are used across the Login UI
class LoginBuilder {
  // Specific Login TextFormField
  static Widget textFormField({
    required TextEditingController controller,
    required String hint,
    bool? isPassword,
  }) {
    /// Assigns bools in Constructor to new Variable
    ///
    /// * when the bool is defined it is set to the Constructors value
    /// * when the bool is undefined it is set to false
    bool password = isPassword ?? false;
    return SizedBox(
      height: 60,
      child: TextFormField(
        // Passes specific Controller to TextField
        controller: controller,

        /// Alters obscure text
        ///
        /// * password == false -> Text normally shown
        /// * password == true -> Text obscured
        obscureText: password,

        // Validates input
        validator: (value) {
          /// When no String is inputted an error is thrown
          ///
          /// * password == false -> nullFieldError
          /// * password == true -> nullPasswordError
          if (value == "") {
            return password ? Const.nullPasswordError : Const.nullFieldError;
          } else {
            // When the password is smaller than six chars -> lengthError
            if (value!.length < 6 && password) {
              return Const.lengthError;
            } else {
              return null;
            }
          }
        },

        // Suggestions & autocorrect disabled
        enableSuggestions: false,
        autocorrect: false,

        // Style
        cursorColor: const Color(0xff7434E6),
        style: const TextStyle(color: Color(0xff7434E6)),
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
