import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/request_absence.dart';
import 'package:gest_absence_frontend/models/seance.dart';
import 'package:gest_absence_frontend/models/utilisateur.dart';
import 'package:gest_absence_frontend/screens/etudiant/absences_screen.dart';
import 'package:gest_absence_frontend/services/absence_service.dart';
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
  Map<int, bool> absences = {};
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
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
              ],
            );
          },
        ),
        const Text("liste des etudiants"),
        FutureBuilder(
          future: futureEtudiants,
          builder: (context, snapshot) {
            if (snapshot.connectionState == .waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Center(child: const Text("error"));
            }
            final etudiants = snapshot.data!;
            absences = {for (var etudiant in etudiants) etudiant.id: false};
            return ListView.builder(
              itemCount: etudiants.length,
              itemBuilder: (context, index) => CheckboxListTile(
                value: absences[etudiants[index].id],
                onChanged: (v) {
                  absences[etudiants[index].id] = v ?? false;
                },
                title: Text(
                  "${etudiants[index].nom} ${etudiants[index].prenom}",
                ),
                subtitle: Text("${etudiants[index].id}"),
              ),
            );
          },
        ),
        FilledButton(
          onPressed: submit,
          child: const Row(
            children: [Icon(Icons.checklist), Text("Valider l'appel")],
          ),
        ),
      ],
    );
  }

  Future<void> submit() async {
    final request = RequestAbsence(seanceId: widget.id, absences: absences);
    final service = AbsenceService();
    service.sendAppel(request);
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
