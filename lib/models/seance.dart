class Seance {
  final int id;

  final String matiere;
  final int matiereId;

  final String date;
  final String heureDebut;
  final String heureFin;

  final String classeNom;
  final int classeId;

  final int enseignantId;

  Seance({
    required this.id,
    required this.matiere,
    required this.date,
    required this.heureDebut,
    required this.heureFin,
    required this.classeNom,
    required this.matiereId,
    required this.classeId,
    required this.enseignantId,
  });

  factory Seance.fromJson(Map<String, dynamic> json) {
    return Seance(
      id: json["id"] as int? ?? 0,
      matiere: json["matiere_nom"],
      matiereId: json["matiere_id"] as int? ?? 0,
      classeId: json["classe_id"] as int? ?? 0,
      enseignantId: json["enseignant_id"] as int? ?? 0,
      date: json["date_seance"],
      heureDebut: json["heure_debut"],
      heureFin: json["heure_fin"],
      classeNom: json["classe_nom"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "matiere_id": matiereId,
      "classe_id": classeId,
      "enseignant_id": enseignantId,
      "date_seance": date,
      "heure_debut": heureDebut,
      "heure_fin": heureFin,
    };
  }
}
