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
    if (searchController.text.isEmpty) return seances;
    return seances
        .where(
          (seance) =>
              seance.matiere.toLowerCase().contains(
                searchController.text.toLowerCase(),
              ) ||
              seance.classeNom.toLowerCase().contains(
                searchController.text.toLowerCase(),
              ),
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
            mainAxisAlignment: .spaceBetween,
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
            onChanged: (value) => setState(() {
              searchQuery = value;
            }),
            decoration: InputDecoration(
              hintText: "Rechercher une séance...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: .circular(8)),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          searchQuery = "";
                        });
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
              if (snapshot.connectionState == .waiting) {
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
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.primaryContainer,
                        child: Icon(
                          Icons.calendar_today_outlined,
                          color: colorScheme.onPrimaryContainer,
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
                        mainAxisSize: .min,
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
  late final bool isEdit;
  bool _isLoading = true;
  String? _error;

  List<Enseignant> enseignants = [];
  List<Classe> classes = [];
  List<Matiere> matieres = [];

  Enseignant? selectedEnseignant;
  Classe? selectedClasse;
  Matiere? selectedMatiere;

  DateTime? selectedDate;
  TimeOfDay? heureDebut;
  TimeOfDay? heureFin;

  @override
  void initState() {
    super.initState();
    isEdit = widget.seance != null;
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        EnseignantService().getEnseignants(),
        ClasseService().getClasses(),
        MatiereService().getMatieres(),
      ]);
      if (!mounted) return;
      setState(() {
        enseignants = results[0] as List<Enseignant>;
        classes = results[1] as List<Classe>;
        matieres = results[2] as List<Matiere>;
        if (widget.seance != null) {
          final s = widget.seance!;
          selectedEnseignant = enseignants.firstWhere(
            (e) => e.id == s.enseignantId,
          );
          selectedClasse = classes.firstWhere((c) => c.id == s.classeId);
          selectedMatiere = matieres.firstWhere((m) => m.id == s.matiereId);
          selectedDate = DateTime.tryParse(s.date);
          heureDebut = _parseTime(s.heureDebut);
          heureFin = _parseTime(s.heureFin);
        }
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
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

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => isStart ? heureDebut = picked : heureFin = picked);
    }
  }

  Widget _timePicker(String label, TimeOfDay? value, VoidCallback onTap) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.access_time_outlined, size: 18),
        label: Text(value == null ? label : value.format(context)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? "Modifier la séance" : "Ajouter une séance"),
      content: _isLoading
          ? const SizedBox(child: Center(child: CircularProgressIndicator()))
          : _error != null
          ? Text("Erreur: $_error")
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<Enseignant>(
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
                  DropdownButtonFormField<Classe>(
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
                  DropdownButtonFormField<Matiere>(
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
                  OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today_outlined, size: 18),
                    label: Text(
                      selectedDate == null
                          ? "Choisir une date"
                          : DateFormat(
                              "d MMMM yyyy",
                              "fr_FR",
                            ).format(selectedDate!),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _timePicker(
                        "Heure début",
                        heureDebut,
                        () => _pickTime(true),
                      ),
                      const SizedBox(width: 12),
                      _timePicker(
                        "Heure fin",
                        heureFin,
                        () => _pickTime(false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submit,
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
      enseignantId: selectedEnseignant!.id!,
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
