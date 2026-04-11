class Enseignant {
  final int id;
  final String nom;
  final String prenom;

  Enseignant({required this.id, required this.nom, required this.prenom});
  factory Enseignant.fromJson(Map<String, dynamic> json) {
    return Enseignant(
      id: json["id"] as int? ?? 0,
      nom: json["nom"],
      prenom: json["prenom"],
    );
  }
}
