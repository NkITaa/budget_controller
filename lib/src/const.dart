class Const {
  static const List<String> userRoles = ["Manager", "Owner", "Admin"];

  static const String basicInput = "[0-9a-zA-Z &üöäßÜÖÄ@€.-]";

  static const String numInput = "[0-9,. €]";

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

  static const String logoPath = "assets/logo.png";
}
