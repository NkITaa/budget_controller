import 'package:budget_controller/src/pages/manager/const_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../modells/user.dart';

class Manager extends StatefulWidget {
  const Manager({super.key, required this.user});
  final CustomUser user;
  @override
  State<Manager> createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Manager"),
        OutlinedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: const Text(CManager.signOut),
        ),
        TextField(
          controller: nameController,
        ),
      ],
    );
  }
}
