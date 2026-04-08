class ApiConfig {
  static const String baseUrl = "http://172.18.133.53:8000/gest_absence_api";

  static const String login = "$baseUrl/auth/login.php";

  static const String classes = "$baseUrl/admin/classes.php";

  static const String etudiantAbsence = "$baseUrl/etudiant/absences.php";
  static const String etudiantProfile = "$baseUrl/etudiant/profil.php";

  static const String adminStats = "$baseUrl/admin/stats.php";
  static const String etudiants = "$baseUrl/admin/etudiants.php";
  static const String seances = "$baseUrl/admin/seances.php";

  static const String enseignants = "$baseUrl/admin/enseignants.php";
  static const String enseignantsSeance = "$baseUrl/enseignant/seances.php";
  static const String enseignantsAbsence = "$baseUrl/enseignant/absences.php";
  static const String enseignantsClasse = "$baseUrl/enseignants/classe.php";
}
