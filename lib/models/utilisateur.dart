enum Role { admin, enseignant, etudiant, unknown }

class Utilisateur {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final Role role;
  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
  });
  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json["user_id"] ?? json["id"],
      nom: json["nom"],
      prenom: json["prenom"],
      email: json["email"] ?? "",
      role: roleFromString(json["role"]),
    );
  }
}

Role roleFromString(String? role) {
  switch (role) {
    case 'admin':
      return .admin;
    case 'enseignant':
      return .enseignant;
    case 'etudiant':
      return .etudiant;
    default:
      return .unknown;
  }
}
