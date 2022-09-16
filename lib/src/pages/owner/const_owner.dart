class COwner {
  static const double criticalPercentile = 0.8;

  static const String signOut = "Sign out";

  static const String isPrice = "Ist-Kosten";

  static const String shouldPrice = "Soll-Kosten";

  static const String details = "Detaills";

  static const String budget = "Budget";

  static const String costs = "Kosten";

  static const String abort = "Abbrechen";

  static const String close = "Schließen";

  static const String add = "Hinzufügen";

  static List<String> arten = ["Garage", "Mensa", "Personal"];

  static List<String> costAttributes = ["Beschreibung", "Grund", "Summe"];

  static const List<String> columns = [
    "Datum",
    "Kategorie",
    "Summe",
    "Beschreibung",
    "Grund",
    "Verantwortlich",
    ""
  ];
}
