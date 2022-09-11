import 'package:budget_controller/src/Constants/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Owner extends StatelessWidget {
  const Owner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Owner"),
        OutlinedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: const Text(Const.signOut),
        ),
      ],
    );
  }
}
