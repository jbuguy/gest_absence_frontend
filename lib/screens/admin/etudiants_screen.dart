import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/utilisateur.dart';
import 'package:gest_absence_frontend/services/etudiant_service.dart';

class EtudiantsScreen extends StatefulWidget {
  const EtudiantsScreen({super.key});

  @override
  State<EtudiantsScreen> createState() => _EtudiantsScreenState();
}

class _EtudiantsScreenState extends State<EtudiantsScreen> {
  late Future<List<Utilisateur>> futureEtudiants;

  @override
  void initState() {
    super.initState();
    futureEtudiants = EtudiantService().getEtudiants();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Utilisateur>>(
      future: futureEtudiants,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Aucun étudiant trouvé"));
        }
        final etudiants = snapshot.data!;
        return ListView.builder(
          itemCount: etudiants.length,
          itemBuilder: (context, index) {
            final etudiant = etudiants[index];
            return ListTile(
              title: Text("${etudiant.prenom} ${etudiant.nom}"),
              subtitle: Text("ID: ${etudiant.id}"),
            );
          },
        );
      },
    );
  }
}
