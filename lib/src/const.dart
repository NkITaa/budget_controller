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

  static const String unknownError =
      "Unvorhergesehener Fehler, kontaktiere den Administrator";

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
}
