import 'package:budget_controller/src/pages/owner/components/owner_builder.dart';
import 'package:flutter/material.dart';

import '../../../widget_builder.dart';

class Detaills extends StatefulWidget {
  const Detaills({super.key});
  @override
  State<Detaills> createState() => _DetaillsState();
}

class _DetaillsState extends State<Detaills> {
  bool enabled = false;
  void toggle() {
    enabled = !enabled;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBuilder.customAppBar(context: context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OwnerBuilder.detaillsColumn(
                    context: context,
                    budget: false,
                    enabled: enabled,
                    toggle: toggle),
                OwnerBuilder.detaillsColumn(
                    context: context, budget: true, enabled: enabled)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
