class Budget {
  String type;
  double value;

  Budget({
    required this.type,
    required this.value,
  });

  Map<String, dynamic> toJson() {
    return {"type": type, "value": value};
  }

  static Budget fromJson(dynamic budget) {
    return Budget(
      type: budget["type"],
      value: budget["value"],
    );
  }
}
