class ApiConfig {
  static const baseUrl =
      "http://172.26.209.97:8000/gest_absence_api"; // Enlève /gest_absence_api ici
  static const login = "$baseUrl/auth/login.php";

  static const classes = "$baseUrl/admin/classes.php";

  static const adminStats = "$baseUrl/admin/stats.php";
  static const adminEtudiants = "$baseUrl/admin/etudiants.php";
  static const adminSeance = "$baseUrl/admin/seances.php";
  static const adminEnseignant = "$baseUrl/admin/enseignants.php";
  static const adminMatiere = "$baseUrl/admin/matiere.php";

  static const enseignantsSeance = "$baseUrl/enseignant/seances.php";
  static const enseignantsAbsence = "$baseUrl/enseignant/absences.php";
  static const enseignantsClasse = "$baseUrl/enseignant/classe.php";

  static const etudiantAbsence = "$baseUrl/etudiant/absences.php";
  static const etudiantProfile = "$baseUrl/etudiant/profil.php";
}
