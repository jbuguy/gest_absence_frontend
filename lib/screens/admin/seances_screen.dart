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
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    futureSeances = _loadSeances();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<List<Seance>> _loadSeances() async =>
      SeanceService().getSeancesAdmin();

  Future<void> _refreshData() async {
    setState(() {
      futureSeances = _loadSeances();
    });
  }

  List<Seance> _filterSeances(List<Seance> seances) {
    if (searchQuery.isEmpty) return seances;
    return seances
        .where(
          (seance) =>
              seance.matiere.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              seance.classeNom.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              seance.date.contains(searchQuery),
        )
        .toList();
  }

  void _deleteSeance(Seance seance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: Text(
          "Êtes-vous sûr de vouloir supprimer la séance de ${seance.matiere} ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await SeanceService().deleteSeance(seance.id);
                if (!context.mounted) return;
                Navigator.pop(context);
                _refreshData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Séance supprimée avec succès")),
                );
              } catch (e) {
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Erreur: $e")));
              }
            },
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Séances",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              FilledButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) =>
                      SeanceDetailDialog(onSuccess: _refreshData),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Ajouter"),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Rechercher une séance...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                      },
                    )
                  : null,
            ),
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
                return Center(child: Text("Erreur: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Aucune séance trouvée"));
              }
              final filteredSeances = _filterSeances(snapshot.data!);
              if (filteredSeances.isEmpty) {
                return const Center(
                  child: Text("Aucune séance ne correspond à votre recherche"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredSeances.length,
                itemBuilder: (context, index) {
                  final seance = filteredSeances[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.calendar_today_outlined,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        seance.matiere,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "${seance.date} · ${seance.heureDebut} – ${seance.heureFin}",
                        ),
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
                            icon: Icon(
                              Icons.edit_outlined,
                              color: colorScheme.primary,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _deleteSeance(seance),
                            icon: Icon(
                              Icons.delete_outline,
                              color: colorScheme.error,
                            ),
                          ),
                        ],
                      ),
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
    if (!isFirst) return;
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
    if (picked != null) setState(() => selectedDate = picked);
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(isEdit ? "Modifier la séance" : "Ajouter une séance"),
      content: FutureBuilder(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Text("Erreur: ${snapshot.error}");
          }
          initData(snapshot.data!);
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField(
                  initialValue: selectedEnseignant,
                  decoration: const InputDecoration(
                    labelText: "Enseignant",
                    border: OutlineInputBorder(),
                  ),
                  items: enseignants
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text("${e.prenom} ${e.nom}"),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => selectedEnseignant = v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField(
                  initialValue: selectedClasse,
                  decoration: const InputDecoration(
                    labelText: "Classe",
                    border: OutlineInputBorder(),
                  ),
                  items: classes
                      .map(
                        (c) => DropdownMenuItem(value: c, child: Text(c.nom)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => selectedClasse = v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField(
                  initialValue: selectedMatiere,
                  decoration: const InputDecoration(
                    labelText: "Matière",
                    border: OutlineInputBorder(),
                  ),
                  items: matieres
                      .map(
                        (m) => DropdownMenuItem(value: m, child: Text(m.nom)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => selectedMatiere = v),
                ),
                const SizedBox(height: 12),
                // Date picker row
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: colorScheme.primary,
                    size: 18,
                  ),
                  label: Text(
                    selectedDate == null
                        ? "Choisir une date"
                        : DateFormat(
                            "d MMMM yyyy",
                            "fr_FR",
                          ).format(selectedDate!),
                    style: TextStyle(
                      color: selectedDate == null
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurface,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickTime(true),
                        icon: Icon(
                          Icons.access_time_outlined,
                          color: colorScheme.primary,
                          size: 18,
                        ),
                        label: Text(
                          heureDebut == null
                              ? "Heure début"
                              : heureDebut!.format(context),
                          style: TextStyle(
                            color: heureDebut == null
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickTime(false),
                        icon: Icon(
                          Icons.access_time_outlined,
                          color: colorScheme.primary,
                          size: 18,
                        ),
                        label: Text(
                          heureFin == null
                              ? "Heure fin"
                              : heureFin!.format(context),
                          style: TextStyle(
                            color: heureFin == null
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
          child: Text(isEdit ? "Modifier" : "Ajouter"),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tous les champs sont requis")),
      );
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
      heureDebut:
          "${heureDebut!.hour}:${heureDebut!.minute.toString().padLeft(2, '0')}:00",
      heureFin:
          "${heureFin!.hour}:${heureFin!.minute.toString().padLeft(2, '0')}:00",
    );
    try {
      if (!isEdit) {
        await SeanceService().createSeance(seance);
      } else {
        await SeanceService().updateSeance(seance);
      }
      if (!mounted) return;
      Navigator.pop(context);
      widget.onSuccess();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    }
  }
}
