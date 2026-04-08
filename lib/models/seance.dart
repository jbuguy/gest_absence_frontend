class Seance {
  final int id;
  final String matiere;
  final String date;
  final String heureDebut;
  final String heureFin;
  final String classeNom;

  Seance({
    required this.id,
    required this.matiere,
    required this.date,
    required this.heureDebut,
    required this.heureFin,
    required this.classeNom,
  });

  factory Seance.fromJson(Map<String, dynamic> json) {
    return Seance(
      id: json["id"] as int? ?? 0,
      matiere: json["matiere_nom"],
      date: json["date_seance"],
      heureDebut: json["heure_debut"],
      heureFin: json["heure_fin"],
      classeNom: json["classe_nom"] ?? "",
    );
  }
}
