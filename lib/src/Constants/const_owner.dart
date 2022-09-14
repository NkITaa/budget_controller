import 'package:cloud_firestore/cloud_firestore.dart';

import '../modells/cost.dart';

class COwner {
  static const double criticalPercentile = 0.8;

  static const String signOut = "Sign out";

  static const String isPrice = "Ist-Kosten";

  static const String shouldPrice = "Soll-Kosten";

  static const String details = "Detaills";

  static const List<String> columns = [
    "Datum",
    "Bezeichnung",
    "Kategorie",
    "Summe",
    "Verantwortlich",
    ""
  ];

  static List<Cost> costs = [
    Cost(
        responsibility: "responsibility",
        name: "name",
        type: "type",
        value: 3,
        creation: Timestamp.now()),
    Cost(
        responsibility: "responsibility",
        name: "name",
        type: "type",
        value: 5,
        creation: Timestamp.now())
  ];
}
