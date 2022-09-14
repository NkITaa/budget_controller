import 'package:cloud_firestore/cloud_firestore.dart';

class Cost {
  String responsibility;
  String name;
  String type;
  double value;
  Timestamp creation;

  Cost({
    required this.responsibility,
    required this.name,
    required this.type,
    required this.value,
    required this.creation,
  });

  Map<String, dynamic> toJson() {
    return {
      "responsibility": responsibility,
      "name": name,
      "type": type,
      "value": value,
      "creation": creation
    };
  }

  static Cost fromJson(dynamic cost) {
    return Cost(
      responsibility: cost["responsibility"],
      name: cost["name"],
      type: cost["type"],
      value: cost["value"],
      creation: cost["creation"],
    );
  }
}
