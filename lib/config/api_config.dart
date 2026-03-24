class ApiConfig {
  static const String baseUrl = "http://10.0.2.2/gest_absence_api";

  static const String login = "$baseUrl/auth/login.php";

  static const String classes = "$baseUrl/classes";

  static const String etudiants = "$baseUrl/etudiants/";
  static String etudiantsAbsence = "$baseUrl/etudiants/absences.php";
}
