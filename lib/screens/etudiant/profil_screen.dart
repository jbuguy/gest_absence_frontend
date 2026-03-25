import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/profile.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  Profile futureProfile = Profile(
    nom: "anime",
    prenom: "trabelsi",
    email: "amine@school.tn",
    classNom: "CI2-A",
    niveau: "cycle enginner 2",
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          CircleAvatar(radius: 30, child: Text("AT")),
          Text("${futureProfile.prenom} ${futureProfile.nom}"),
          Chip(label: Text(futureProfile.classNom)),
          Card(
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.description),
                    SizedBox(width: 8),
                    const Text("Informations personnelles"),
                  ],
                ),
                _buildInfoItem(
                  icon: Icons.alternate_email,
                  label: "email professionnel",
                  value: "amine@school.tn",
                ),
                _buildInfoItem(
                  icon: Icons.class_,
                  label: "classe",
                  value: "Cycle Ingénieur 2",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: .center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 24),
          ),
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(label.toUpperCase()),
              const SizedBox(height: 2),
              Text(value),
            ],
          ),
        ],
      ),
    );
  }
}
