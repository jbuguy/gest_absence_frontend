import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/profile.dart';
import 'package:gest_absence_frontend/services/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  late Future<Profile> futureProfile;
  @override
  void initState() {
    super.initState();

    futureProfile = _loadProfile();
  }

  Future<Profile> _loadProfile() async {
    final prefrences = await SharedPreferences.getInstance();
    final userId = prefrences.getInt("user_id");
    if (userId == null) {
      throw Exception("User not logged in ");
    }
    final profileService = ProfileService();

    return profileService.getProfile(userId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: futureProfile,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == .waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (asyncSnapshot.hasError) {
            return Center(child: Text("Error: ${asyncSnapshot.error}"));
          }
          if (!asyncSnapshot.hasData) {
            return Center(child: Text("No data"));
          }
          final profile = asyncSnapshot.data!;
          return Column(
            children: [
              CircleAvatar(
                radius: 30,
                child: Text("${profile.prenom[0]}${profile.nom[0]}"),
              ),
              Text("${profile.prenom} ${profile.nom}"),
              Chip(label: Text(profile.classNom)),
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
                      value: profile.email,
                    ),
                    _buildInfoItem(
                      icon: Icons.class_,
                      label: "classe",
                      value: profile.niveau,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
