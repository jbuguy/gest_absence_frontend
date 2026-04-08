import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/seance.dart';
import 'package:gest_absence_frontend/models/utilisateur.dart';
import 'package:gest_absence_frontend/services/etudiant_service.dart';
import 'package:gest_absence_frontend/services/seance_service.dart';

class AppelScreen extends StatefulWidget {
  final int id;
  const AppelScreen({super.key, required this.id});

  @override
  State<AppelScreen> createState() => _AppelScreenState();
}

class _AppelScreenState extends State<AppelScreen> {
  late Future<Seance> futureSeance;
  late Future<List<Utilisateur>> futureEtudiants;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureSeance,
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Center(child: const Text("error"));
        }
        final seance = snapshot.data!;
        return Column(
          children: [
            Card(
              child: Column(
                children: [const Text("Cours"), Text(seance.matiere)],
              ),
            ),
            const Text("liste des etudiants"),
            ListView.builder(
              itemBuilder: (context, index) => CheckboxListTile(
                value: false,
                onChanged: (v) {},
                title: Text("#"),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    futureSeance = _loadSeance();
    futureEtudiants = _loadEtudiants();
  }

  Future<List<Utilisateur>> _loadEtudiants() async {
    final id = widget.id;
    final service = EtudiantService();
    return service.getEtudiantsByClasse(id);
  }

  Future<Seance> _loadSeance() async {
    final id = widget.id;
    final service = SeanceService();
    return service.getSeance(id);
  }
}
