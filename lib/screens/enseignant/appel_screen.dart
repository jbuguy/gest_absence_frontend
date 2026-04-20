import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/request_absence.dart';
import 'package:gest_absence_frontend/models/seance.dart';
import 'package:gest_absence_frontend/models/utilisateur.dart';
import 'package:gest_absence_frontend/services/absence_service.dart';
import 'package:gest_absence_frontend/services/etudiant_service.dart';

class AppelScreen extends StatefulWidget {
  final Seance seance;
  const AppelScreen({super.key, required this.seance});

  @override
  State<AppelScreen> createState() => _AppelScreenState();
}

class _AppelScreenState extends State<AppelScreen> {
  late Future<List<Utilisateur>> futureEtudiants;
  Map<int, bool> absences = {};
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feuille d'appel"),
        leading: const BackButton(),
      ),

      body: FutureBuilder(
        future: futureEtudiants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == .waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("error ${snapshot.error}"));
          }
          final etudiants = snapshot.data ?? [];
          if (absences.isEmpty) {
            absences = {for (var e in etudiants) e.id: false};
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          "COURS ACTUEL",
                          style: theme.primaryTextTheme.labelLarge?.copyWith(
                            color: colorScheme.primaryContainer,
                          ),
                        ),
                        Text(
                          widget.seance.matiere,
                          style: theme.primaryTextTheme.headlineLarge,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: .symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: colorScheme.onPrimaryContainer,
                                borderRadius: .circular(20),
                              ),
                              child: Text(
                                widget.seance.classeNom,
                                style: theme.primaryTextTheme.labelLarge
                                    ?.copyWith(fontWeight: .bold),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              padding: .symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: colorScheme.onPrimaryContainer,
                                borderRadius: .circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.schedule),
                                  Text(
                                    "${widget.seance.heureDebut} - ${widget.seance.heureFin}",
                                    style: theme.primaryTextTheme.labelLarge
                                        ?.copyWith(fontWeight: .bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Text(
                  "liste des etudiants",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: .bold,
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: etudiants.length,
                    itemBuilder: (context, index) {
                      final etudiant = etudiants[index];

                      return CheckboxListTile(
                        value: absences[etudiant.id],
                        onChanged: (v) {
                          setState(() {
                            absences[etudiant.id] = v ?? false;
                          });
                        },
                        title: Text("${etudiant.nom} ${etudiant.prenom}"),
                        subtitle: Text(
                          absences[etudiant.id] == true ? "Absent" : "Présent",
                          style: TextStyle(
                            color: absences[etudiant.id] == true
                                ? Colors.red
                                : Colors.green,
                            fontWeight: .w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                FilledButton.icon(
                  onPressed: submit,
                  icon: Icon(Icons.checklist),
                  label: Text(
                    "Valider l'appel",
                    style: theme.primaryTextTheme.bodyMedium?.copyWith(
                      fontWeight: .w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> submit() async {
    final request = RequestAbsence(
      seanceId: widget.seance.id,
      absences: absences,
    );
    final service = AbsenceService();
    try {
      await service.sendAppel(request);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    }
  }

  @override
  void initState() {
    super.initState();
    futureEtudiants = _loadEtudiants();
  }

  Future<List<Utilisateur>> _loadEtudiants() async {
    final id = widget.seance.id;
    final service = EtudiantService();
    return service.getEtudiantsByClasse(id);
  }
}
