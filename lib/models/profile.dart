class Profile {
  final String nom;
  final String prenom;
  final String email;
  final String classNom;
  final String niveau;
  Profile({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.classNom,
    required this.niveau,
  });
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      nom: json["nom"],
      prenom: json["prenom"],
      email: json["email"],
      classNom: json["classe_nom"] ?? "",
      niveau: json["niveau"] ?? "",
    );
  }
}
