import 'package:cloud_firestore/cloud_firestore.dart';

class Cost {
  String responsibility;
  String type;
  double value;
  Timestamp creation;

  Cost({
    required this.responsibility,
    required this.type,
    required this.value,
    required this.creation,
  });

  Map<String, dynamic> toJson() {
    return {
      "responsibility": responsibility,
      "type": type,
      "value": value,
      "creation": creation
    };
  }

  static Cost fromJson(dynamic cost) {
    return Cost(
      responsibility: cost["responsibility"],
      type: cost["type"],
      value: cost["value"],
      creation: cost["creation"],
    );
  }
}
