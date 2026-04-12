class Enseignant {
  final int? id; // ID de la table enseignants
  final int? userId; // ID de la table utilisateurs
  final String nom;
  final String prenom;
  final String? email;
  final String? specialite;
  final int? matiereId;

  Enseignant({
    this.id,
    this.userId,
    required this.nom,
    required this.prenom,
    this.email,
    this.specialite,
    this.matiereId,
  });

  factory Enseignant.fromJson(Map<String, dynamic> json) {
    return Enseignant(
      id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()),
      userId: json["user_id"] is int ? json["user_id"] : int.tryParse(json["user_id"].toString()),
      nom: json["nom"] ?? "",
      prenom: json["prenom"] ?? "",
      email: json["email"] ?? "",
      specialite: json["specialite"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "nom": nom,
      "prenom": prenom,
    };
    if (userId != null) data["utilisateur_id"] = userId;
    if (email != null) data["email"] = email;
    if (specialite != null) data["specialite"] = specialite;
    if (matiereId != null) data["matiere_id"] = matiereId;
    return data;
  }
}