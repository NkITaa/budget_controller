import 'package:cloud_firestore/cloud_firestore.dart';

class Projection {
  String type;
  double value;

  Projection({
    required this.type,
    required this.value,
  });

  Map<String, dynamic> toJson() {
    return {"type": type, "value": value};
  }

  static Projection fromJson(DocumentSnapshot<Object?> projection) {
    return Projection(
      type: projection["type"],
      value: projection["value"],
    );
  }
}
