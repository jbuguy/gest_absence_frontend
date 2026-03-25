class Seance {
  final int id;
  final String matiere;
  final String date;
  final String heureDebut;
  final String heureFin;
  final String salle;

  Seance({
    required this.id,
    required this.matiere,
    required this.date,
    required this.heureDebut,
    required this.heureFin,
    required this.salle,
  });

  factory Seance.fromJson(Map<String, dynamic> json) {
    return Seance(
      id: json["id"] as int? ?? 0,
      matiere: json["matiere"],
      date: json["date"],
      heureDebut: json["heure_debut"],
      heureFin: json["heure_fin"],
      salle: json["salle"],
    );
  }
}
