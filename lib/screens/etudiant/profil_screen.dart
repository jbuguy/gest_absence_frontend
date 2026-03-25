import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/profile.dart';
import 'package:gest_absence_frontend/services/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  Future<Profile> _loadProfile() async {
    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getInt("user_id");
    if (userId == null) {
      throw Exception("User not logged in");
    }
    final profileService = ProfileService();
    return profileService.getProfile(userId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<Profile>(
        future: _loadProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No data"));
          }
          final profile = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32.0,
              horizontal: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
            ),
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
