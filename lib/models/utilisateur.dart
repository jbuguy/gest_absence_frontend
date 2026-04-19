enum Role { admin, enseignant, etudiant, unknown }

class Utilisateur {
  final int id;
  final String nom;
  final String prenom;
  final Role role;
  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.role,
  });
  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json["user_id"] ?? json["id"],
      nom: json["nom"],
      prenom: json["prenom"],
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
