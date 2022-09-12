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
}
