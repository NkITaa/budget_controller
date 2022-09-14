import 'package:flutter/material.dart';

import '../constants/const_owner.dart';
import '../pages/detaills.dart';

class OwnerComponents {
  static Widget buildComparison(
      {required double isPrice,
      required double shouldPrice,
      required BuildContext context}) {
    bool critical = false;
    isPrice / shouldPrice > COwner.criticalPercentile
        ? critical = true
        : critical = false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 4, right: 4, bottom: 4),
              child: Text(
                COwner.isPrice,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Text("${isPrice.toStringAsFixed(2)}€",
                  style: TextStyle(
                      color: critical ? Colors.red : Colors.green,
                      fontSize: 22)),
            )
          ],
        ),
        const SizedBox(
          width: 50,
        ),
        Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 4, right: 4, bottom: 4),
              child: Text(
                COwner.shouldPrice,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text("${shouldPrice.toStringAsFixed(2)}€",
                  style: const TextStyle(color: Colors.black, fontSize: 22)),
            )
          ],
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          color: const Color(0xff7434E6),
          iconSize: 30,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Detaills())),
        ),
      ],
    );
  }
}
