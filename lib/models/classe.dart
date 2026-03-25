class Classe {
  final int id;
  final String nom;
  final String niveau;

  Classe({required this.id, required this.nom, required this.niveau});

  factory Classe.fromJson(Map<String, dynamic> json) {
    return Classe(id: json["id"], nom: json["nom"], niveau: json["niveau"]);
  }
}
