class COwner {
  static const double criticalPercentile = 0.8;

  static const String isPrice = "Ist-Kosten";

  static const String shouldPrice = "Soll-Kosten";

  static const String details = "Detaills";

  static const String budget = "Budget";

  static const String costs = "Kosten";

  static const String abort = "Abbrechen";

  static const String close = "Schließen";

  static const String add = "Hinzufügen";

  static const String submit = "Einreichen";

  static const String newBudgetTitle = "Budget Einreichen";

  static const String addedCost = "Ausgabe Hinzugefügt";

  static const String deleteWarning =
      "Möchtest du die Ausgabe wirklich löschen?";

  static const String addCost = "Ausgabe Hinzufügen";

  static const String noProject =
      "Kein Projekt zugeordnet, kontaktiere das Management";

  static const inAudit = "Dein Budgetentwurf wird geprüft";

  static const List<String> costSections = [
    "Personalkosten",
    "Sachkosten",
  ];

  static const List<String> typesHints = [
    "IT-Kosten",
    "Vertriebs-Kosten",
    "Rechts-Kosten",
    "Management-Kosten",
    "Hardware-Kosten",
    "Software-Kosten"
  ];

  static const List<String> costAttributes = ["Beschreibung", "Grund", "Summe"];

  static const List<String> columns = [
    "Datum",
    "Kategorie",
    "Summe",
    "Beschreibung",
    "Grund",
    ""
  ];
}
