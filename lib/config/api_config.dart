class ApiConfig {
  static const baseUrl = "http://192.168.1.127:8000/gest_absence_api";

  static const login = "$baseUrl/auth/login.php";

  static const classes = "$baseUrl/admin/classes.php";

  static const etudiantAbsence = "$baseUrl/etudiant/absences.php";
  static const etudiantProfile = "$baseUrl/etudiant/profil.php";

  static const adminStats = "$baseUrl/admin/stats.php";
  static const etudiants = "$baseUrl/admin/etudiants.php";
  static const seances = "$baseUrl/admin/seances.php";

  static const enseignants = "$baseUrl/admin/enseignants.php";
  static const enseignantsSeance = "$baseUrl/enseignant/seances.php";
  static const enseignantsAbsence = "$baseUrl/enseignant/absences.php";
  static const enseignantsClasse = "$baseUrl/enseignant/classe.php";
}
