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

  @override
  void initState() {
    super.initState();

    futureClasses = _loadClasses();
  }

  Future<List<Classe>> _loadClasses() async => ClasseService().getClasses();

  Future<void> _refreshData() async {
    setState(() => futureClasses = _loadClasses());
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
                "Gestion des Classes",
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
                        ClasseDetailDialog(onSuccess: _refreshData),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Ajouter"),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Classe>>(
            future: futureClasses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == .waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Aucune classe trouvée"));
              }
              final classes = snapshot.data!;
              return ListView.builder(
                padding: .all(4.0),
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  final classe = classes[index];

                  return ListTile(
                    tileColor: colorScheme.surfaceContainer,
                    title: Text(classe.nom),
                    subtitle: Text("Niveau: ${classe.niveau}"),
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
    niveauController = TextEditingController(text: widget.classe?.niveau ?? "");
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
      title: Text(isEdit ? "Modifier classe" : "Ajouter classe"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nomController,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: niveauController,
              decoration: const InputDecoration(labelText: "Niveau"),
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
          child: Text(isEdit ? "modifier" : "ajouter"),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    }
  }
}
