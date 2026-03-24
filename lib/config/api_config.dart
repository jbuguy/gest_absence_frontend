class ApiConfig {
  static const String baseUrl = "http://192.168.1.4:8000/gest_absence_api";

  static const String login = "$baseUrl/auth/login.php";

  static const String classes = "$baseUrl/classes";

  static const String etudiants = "$baseUrl/etudiant/";
  static String etudiantsAbsence = "$baseUrl/etudiant/absences.php";
}
