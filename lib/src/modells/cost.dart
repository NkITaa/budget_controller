// Definition of Cost Object
class Cost {
  DateTime creation;
  String category;
  double value;
  String reason;
  String description;
  String responsibility;

  Cost({
    required this.creation,
    required this.category,
    required this.value,
    required this.reason,
    required this.description,
    required this.responsibility,
  });

  // Serializes Object to JSON
  Map<String, dynamic> toJson() {
    return {
      "creation": creation,
      "category": category,
      "value": value,
      "reason": reason,
      "description": description,
      "responsibility": responsibility,
    };
  }

  // Serializes Object from JSON
  static Cost fromJson(dynamic cost) {
    return Cost(
      creation: DateTime.parse(cost["creation"].toDate().toString()),
      category: cost["category"],
      value: cost["value"],
      reason: cost["reason"],
      description: cost["description"],
      responsibility: cost["responsibility"],
    );
  }
}
