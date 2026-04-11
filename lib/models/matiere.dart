class Matiere {
  final int id;
  final String nom;

  Matiere({required this.id, required this.nom});

  factory Matiere.fromJson(Map<String, dynamic> json) {
    return Matiere(id: json["id"], nom: json["nom"]);
  }
}
