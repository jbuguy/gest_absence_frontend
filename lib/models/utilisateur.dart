class Utilisateur {
  final int id;
  final String nom;
  final String prenom;
  final String role;
  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.role,
  });
  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json["user_id"],
      nom: json["nom"],
      prenom: json["prenom"],
      role: json["role"] ?? "",
    );
  }
}
