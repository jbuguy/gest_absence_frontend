import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/classe.dart';
import 'package:gest_absence_frontend/services/classe_service.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  late Future<List<Classe>> futureClasses;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    futureClasses = _loadClasses();
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

  Future<List<Classe>> _loadClasses() async => ClasseService().getClasses();

  Future<void> _refreshData() async {
    setState(() {
      futureClasses = _loadClasses();
    });
  }

  List<Classe> _filterClasses(List<Classe> classes) {
    if (searchQuery.isEmpty) return classes;
    return classes
        .where((classe) =>
            classe.nom.toLowerCase().contains(searchQuery.toLowerCase()) ||
            classe.niveau.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  void _deleteClasse(Classe classe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: Text(
            "Êtes-vous sûr de vouloir supprimer la classe ${classe.nom} ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await ClasseService().deleteClasse(classe.id);
                if (!context.mounted) return;
                Navigator.pop(context);
                _refreshData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Classe supprimée avec succès"),
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Erreur: $e")),
                );
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
                "Classes",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              FilledButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ClasseDetailDialog(onSuccess: _refreshData),
                  );
                },
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
              hintText: "Rechercher une classe...",
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
          child: FutureBuilder<List<Classe>>(
            future: futureClasses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Erreur: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Aucune classe trouvée"));
              }
              final filteredClasses = _filterClasses(snapshot.data!);
              if (filteredClasses.isEmpty) {
                return const Center(
                    child: Text("Aucune classe ne correspond à votre recherche"));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredClasses.length,
                itemBuilder: (context, index) {
                  final classe = filteredClasses[index];
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
                          Icons.class_,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        classe.nom,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text("Niveau: ${classe.niveau}"),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => ClasseDetailDialog(
                                classe: classe,
                                onSuccess: _refreshData,
                              ),
                            ),
                            icon: Icon(
                              Icons.edit_outlined,
                              color: colorScheme.primary,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _deleteClasse(classe),
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

class ClasseDetailDialog extends StatefulWidget {
  final Classe? classe;
  final Function onSuccess;
  const ClasseDetailDialog({super.key, this.classe, required this.onSuccess});

  @override
  State<ClasseDetailDialog> createState() => _ClasseDetailDialogState();
}

class _ClasseDetailDialogState extends State<ClasseDetailDialog> {
  late final TextEditingController nomController;
  late final TextEditingController niveauController;
  late final bool isEdit;

  @override
  void initState() {
    super.initState();
    isEdit = widget.classe != null;
    nomController = TextEditingController(text: widget.classe?.nom ?? "");
    niveauController =
        TextEditingController(text: widget.classe?.niveau ?? "");
  }

  @override
  void dispose() {
    nomController.dispose();
    niveauController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? "Modifier la classe" : "Ajouter une classe"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomController,
              decoration: const InputDecoration(
                labelText: "Nom",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: niveauController,
              decoration: const InputDecoration(
                labelText: "Niveau",
                border: OutlineInputBorder(),
              ),
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
          onPressed: _submit,
          child: Text(isEdit ? "Modifier" : "Ajouter"),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    try {
      final service = ClasseService();
      if (!isEdit) {
        await service.addClasse(
          Classe(
            id: -1,
            nom: nomController.text,
            niveau: niveauController.text,
          ),
        );
      } else {
        await service.updateClasse(
          Classe(
            id: widget.classe!.id,
            nom: nomController.text,
            niveau: niveauController.text,
          ),
        );
      }
      if (!context.mounted) return;
      Navigator.pop(context);
      widget.onSuccess();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erreur: $e")));
    }
  }
}