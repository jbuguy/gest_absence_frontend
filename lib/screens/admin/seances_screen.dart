import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/classe.dart';
import 'package:gest_absence_frontend/models/enseignant.dart';
import 'package:gest_absence_frontend/models/matiere.dart';
import 'package:gest_absence_frontend/models/seance.dart';
import 'package:gest_absence_frontend/services/classe_service.dart';
import 'package:gest_absence_frontend/services/enseignant_service.dart';
import 'package:gest_absence_frontend/services/matiere_service.dart';
import 'package:gest_absence_frontend/services/seance_service.dart';
import 'package:intl/intl.dart';

class SeancesScreen extends StatefulWidget {
  const SeancesScreen({super.key});

  @override
  State<SeancesScreen> createState() => _SeancesScreenState();
}

class _SeancesScreenState extends State<SeancesScreen> {
  late Future<List<Seance>> futureSeances;

  @override
  void initState() {
    super.initState();

    futureSeances = _loadSeances();
  }

  Future<List<Seance>> _loadSeances() async =>
      SeanceService().getSeancesAdmin();

  Future<void> _refreshData() async {
    setState(() {
      futureSeances = _loadSeances();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gestion des seance",
                style: theme.primaryTextTheme.headlineLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: .w900,
                ),
              ),
              FilledButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        SeanceDetailDialog(onSuccess: _refreshData),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Ajouter"),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Seance>>(
            future: futureSeances,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Aucune séance trouvée"));
              }
              final seances = snapshot.data!;
              return ListView.builder(
                padding: .all(4.0),
                itemCount: seances.length,
                itemBuilder: (context, index) {
                  final seance = seances[index];

                  return ListTile(
                    tileColor: colorScheme.surfaceContainer,
                    title: Text(seance.matiere),
                    subtitle: Text(
                      "${seance.date} - ${seance.heureDebut} à ${seance.heureFin}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => SeanceDetailDialog(
                              seance: seance,
                              onSuccess: _refreshData,
                            ),
                          ),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class SeanceDetailDialog extends StatefulWidget {
  final Seance? seance;
  final VoidCallback onSuccess;
  const SeanceDetailDialog({super.key, this.seance, required this.onSuccess});

  @override
  State<SeanceDetailDialog> createState() => _SeanceDetailDialogState();
}

class _SeanceDetailDialogState extends State<SeanceDetailDialog> {
  late Future<List<dynamic>> _futureData;
  late final bool isEdit;

  List<Enseignant> enseignants = [];
  List<Classe> classes = [];
  List<Matiere> matieres = [];

  Enseignant? selectedEnseignant;
  Classe? selectedClasse;
  Matiere? selectedMatiere;

  DateTime? selectedDate;
  TimeOfDay? heureDebut;
  TimeOfDay? heureFin;

  bool isFirst = true;
  @override
  void initState() {
    super.initState();

    isEdit = widget.seance != null;
    _futureData = Future.wait([
      EnseignantService().getEnseignants(),
      ClasseService().getClasses(),
      MatiereService().getMatieres(),
    ]);
  }

  void initData(List<dynamic> data) {
    if (!isFirst) {
      return;
    }
    enseignants = data[0];
    classes = data[1];
    matieres = data[2];

    if (widget.seance != null) {
      final s = widget.seance!;

      selectedEnseignant = enseignants.firstWhere(
        (p) => p.id == s.enseignantId,
      );
      selectedClasse = classes.firstWhere((c) => c.id == s.classeId);
      selectedMatiere = matieres.firstWhere((m) => m.id == s.matiereId);

      selectedDate = DateTime.tryParse(s.date);
      heureDebut = _parseTime(s.heureDebut);
      heureFin = _parseTime(s.heureFin);
    }

    isFirst = false;
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          heureDebut = picked;
        } else {
          heureFin = picked;
        }
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? "Add Séance" : "Edit Séance"),
      content: FutureBuilder(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == .waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          initData(snapshot.data!);
          return Column(
            children: [
              DropdownButton<Enseignant>(
                items: enseignants
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.nom)))
                    .toList(),
                onChanged: (v) => setState(() => selectedEnseignant = v),
                hint: const Text("select enesignant"),
                value: selectedEnseignant,
              ),

              DropdownButton<Classe>(
                items: classes
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.nom)))
                    .toList(),
                onChanged: (v) => setState(() => selectedClasse = v),
                hint: const Text("select enesignant"),
                value: selectedClasse,
              ),
              DropdownButton<Matiere>(
                items: matieres
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.nom)))
                    .toList(),
                onChanged: (v) => setState(() => selectedMatiere = v),
                hint: const Text("select enesignant"),
                value: selectedMatiere,
              ),
              TextButton(
                onPressed: _pickDate,
                child: Text(
                  selectedDate == null
                      ? "Pick Date"
                      : selectedDate.toString().split(' ')[0],
                ),
              ),
              TextButton(
                onPressed: () => _pickTime(true),
                child: Text(
                  heureDebut == null
                      ? "Heure début"
                      : heureDebut!.format(context),
                ),
              ),

              TextButton(
                onPressed: () => _pickTime(false),
                child: Text(
                  heureFin == null ? "Heure fin" : heureFin!.format(context),
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(isEdit ? "modifier" : "ajouter"),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (selectedEnseignant == null ||
        selectedClasse == null ||
        selectedMatiere == null ||
        selectedDate == null ||
        heureDebut == null ||
        heureFin == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("All fields are required")));
      return;
    }
    final seance = Seance(
      id: widget.seance?.id ?? -1,
      classeId: selectedClasse!.id,
      classeNom: selectedClasse!.nom,
      enseignantId: selectedEnseignant?.id ?? 0,
      matiereId: selectedMatiere!.id,
      matiere: selectedMatiere!.nom,
      date: DateFormat("yyyy-MM-dd").format(selectedDate!),
      heureDebut: "${heureDebut!.hour}:${heureDebut!.minute}:00",
      heureFin: "${heureFin!.hour}:${heureFin!.minute}:00",
    );
    try {
      if (!isEdit) {
        await SeanceService().createSeance(seance);
      } else {
        await SeanceService().updateSeance(seance);
      }

      if (!context.mounted) return;
      Navigator.pop(context);
      widget.onSuccess();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    }
  }
}
