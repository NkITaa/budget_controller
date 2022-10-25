// Definition of Budget Object
class Budget {
  String type;
  double value;

  Budget({
    required this.type,
    required this.value,
  });

  // Serializes Object to JSON
  Map<String, dynamic> toJson() {
    return {"type": type, "value": value};
  }

  // serializes Object from JSON
  static Budget fromJson(dynamic budget) {
    return Budget(
      type: budget["type"],
      value: budget["value"],
    );
  }
}
