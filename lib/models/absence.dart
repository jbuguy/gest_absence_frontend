class Absence {
  final String dateSeance;
  final String nomMatiere;
  final String heureDebut;
  final String statut;

  Absence({
    required this.dateSeance,
    required this.nomMatiere,
    required this.heureDebut,
    required this.statut,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      dateSeance: json["date_seance"],
      nomMatiere: json["matiere_nom"],
      heureDebut: json["heure_debut"],
      statut: json["statut"],
    );
  }
}
