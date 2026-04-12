class Etudiant {
  final int? id; // utilisateur_id
  final int? etudiantId;
  final String nom;
  final String prenom;
  final String email;
  final String? password;
  final int classeId;
  final String? classeNom;

  Etudiant({
    this.id,
    this.etudiantId,
    required this.nom,
    required this.prenom,
    required this.email,
    this.password,
    required this.classeId,
    this.classeNom,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      id: json["user_id"],
      etudiantId: json["etudiant_id"],
      nom: json["nom"] ?? "",
      prenom: json["prenom"] ?? "",
      email: json["email"] ?? "",
      classeId: 0, // Pas toujours présent dans le GET simple
      classeNom: json["classe_nom"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      "nom": nom,
      "prenom": prenom,
      "email": email,
      "classe_id": classeId,
    };
    if (id != null) data["utilisateur_id"] = id as Object;
    if (password != null) data["password"] = password as Object;
    return data;
  }
}