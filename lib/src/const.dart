// Defines Constants that are used across the whole application
class Const {
  static const List<String> userRoles = ["Manager", "Owner", "Admin"];

  static String currency = "€";

  static String basicInput = "[0-9a-zA-Z &üöäßÜÖÄ@$currency.-]";

  static String numInput = "[0-9,. $currency]";

  static const List<String> costTypes = [
    "IT",
    "Vertrieb",
    "Recht",
    "Management",
    "Hardware",
    "Software"
  ];

  static const List<String> costSections = [
    "Personalkosten",
    "Sachkosten",
  ];

  static const String message = "Nachricht:";

  static const String ticketNum = "Ticket Nummer:";

  static const String from = "Vom:";

  static const String roleUnknows = "User Rolle nicht bekannt";

  static const String lengthError =
      "Das Passwort muss mindestens 6 Zeichen enthalten";

  static const String nullPasswordError = "Bitte gebe ein Password ein";

  static const String nullFieldError = "Das Feld darf nicht leer sein";

  static const String signOut = "Ausloggen";

  static const String approveLogout = "Möchtest du dich wirklich abmelden?";

  static const String changePassword = "Passwort ändern";

  static const String chooseOwner = "Owner auswählen";

  static const String search = "Suchen";

  static const String decisionHistory = "Entscheidungshistorie";

  static const String yes = "Ja";

  static const String no = "Nein";

  static const String logoPath = "assets/logo.png";

  static const String changedRole = "Rolle geändert";

  static const String sentResetMail = "Resetmail gesendet";

  static const String createdUser = "User angelegt";

  static const String createdProject = "Projekt erstellt";

  static const String budgetRejected = "Budget abgelehnt";

  static const String budgetApproved = "Budget angenommen";

  static const String budgetSuggested = "Budget vorgeschlagen";

  static const String budgetUpdated = "Budget bearbeitet";

  static const String addedCost = "Kosten hinzugefügt";

  static const String costDeleted = "Kosten gelöscht";

  static const String costUpdated = "Kosten bearbeitet";

  static const String ownerAdded = "Owner hinzugefügt";

  static const String ownerDeleted = "Owner entfernt";

  static const List<String> resetPasswordLog = [
    "Es wurde eine Resetmail an",
    "von",
    "gesendet"
  ];

  static const List<String> changeRoleLog = [
    "Es wurde die Rolle von",
    "zu",
    "von",
    "geändert"
  ];

  static const List<String> signUpLog = [
    "Der User",
    "wurde mit der Rolle",
    "erstellt"
  ];

  static const List<String> deleteOwnerLog = [
    "Der Owner",
    "wurde von",
    "vom Projekt",
    "entfernt"
  ];

  static const List<String> addOwnerLog = [
    "Der Owner",
    "wurde von",
    "zum Projekt",
    "hinzugefügt"
  ];

  static const List<String> updateBudgetLog = [
    "Das Budget wurde von",
    "im Projekt",
    "geändert"
  ];

  static const List<String> updateCostLog = [
    "Die Kosten für",
    "wurden von",
    "in",
    "geändert"
  ];

  static const List<String> deleteCostLog = [
    "Die Kosten für",
    "wurden von",
    "in",
    "gelöscht"
  ];

  static const List<String> addBudgetsLog = [
    "Budget wurden von",
    "in",
    "vorgeschlagen"
  ];

  static const List<String> addCostLog = [
    "Die Kosten für",
    "wurden von",
    "in",
    "hinzugefügt"
  ];

  static const List<String> acceptBudgetLog = [
    "Der Budgetvorschlag für das Projekt",
    "wurden von",
    "angenommen"
  ];

  static const List<String> deleteBudgetLog = [
    "Der Budgetvorschlag für das Projekt",
    "wurden von",
    "abgelehnt"
  ];

  static const List<String> createProjectLog = [
    "Ein neues Projekt wurde von",
    "mit dem Namen",
    "erstellt. Die ProjektId lautet:",
    ". Die ID des Owners lautet"
  ];
}
