import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/utilisateur.dart';
import 'package:gest_absence_frontend/models/etudiant.dart';
import 'package:gest_absence_frontend/models/classe.dart';
import 'package:gest_absence_frontend/services/etudiant_service.dart';
import 'package:gest_absence_frontend/services/classe_service.dart';

class EtudiantsScreen extends StatefulWidget {
  const EtudiantsScreen({super.key});

  @override
  State<EtudiantsScreen> createState() => _EtudiantsScreenState();
}

class _EtudiantsScreenState extends State<EtudiantsScreen> {
  late Future<List<Utilisateur>> futureEtudiants;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _refreshData() {
    setState(() {
      futureEtudiants = EtudiantService().getEtudiants();
    });
  }

  List<Utilisateur> _filterEtudiants(List<Utilisateur> etudiants) {
    if (searchController.text.isEmpty) return etudiants;
    return etudiants
        .where(
          (u) => "${u.nom} ${u.prenom}".toLowerCase().contains(
            searchController.text.toLowerCase(),
          ),
        )
        .toList();
  }

  void _deleteEtudiant(Utilisateur u) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: Text(
          "Êtes-vous sûr de vouloir supprimer ${u.prenom} ${u.nom} ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await EtudiantService().deleteEtudiant(u.id);
                if (!context.mounted) return;
                Navigator.pop(context);
                _refreshData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Étudiant supprimé avec succès"),
                  ),
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
                "Étudiants",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              FilledButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) =>
                      EtudiantDetailDialog(onSuccess: _refreshData),
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
              hintText: "Rechercher un étudiant...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
          child: FutureBuilder<List<Utilisateur>>(
            future: futureEtudiants,
            builder: (context, snapshot) {
              if (snapshot.connectionState == .waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Erreur: ${snapshot.error}"));
              }
              final filteredEtudiants = _filterEtudiants(snapshot.data!);
              if (filteredEtudiants.isEmpty) {
                return const Center(child: Text("Aucun étudiant trouvé"));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredEtudiants.length,
                itemBuilder: (context, index) {
                  final u = filteredEtudiants[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.secondary.withValues(
                          alpha: 0.12,
                        ),
                        child: Text(
                          u.prenom.isNotEmpty ? u.prenom[0].toUpperCase() : "?",
                          style: TextStyle(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        "${u.prenom} ${u.nom}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text("${u.id}"),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit_outlined,
                              color: colorScheme.primary,
                            ),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => EtudiantDetailDialog(
                                etudiant: u,
                                onSuccess: _refreshData,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: colorScheme.error,
                            ),
                            onPressed: () => _deleteEtudiant(u),
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

class EtudiantDetailDialog extends StatefulWidget {
  final Utilisateur? etudiant;
  final VoidCallback onSuccess;
  const EtudiantDetailDialog({
    super.key,
    this.etudiant,
    required this.onSuccess,
  });

  @override
  State<EtudiantDetailDialog> createState() => _EtudiantDetailDialogState();
}

class _EtudiantDetailDialogState extends State<EtudiantDetailDialog> {
  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  List<Classe> classes = [];
  Classe? selectedClasse;
  bool isEdit = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isEdit = widget.etudiant != null;
    if (isEdit) {
      _nomCtrl.text = widget.etudiant!.nom;
      _prenomCtrl.text = widget.etudiant!.prenom;
    }
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final fetchedClasses = await ClasseService().getClasses();
      setState(() {
        classes = fetchedClasses;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _submit() async {
    if (selectedClasse == null ||
        _nomCtrl.text.isEmpty ||
        _prenomCtrl.text.isEmpty) {
      return;
    }
    final etu = Etudiant(
      id: widget.etudiant?.id,
      nom: _nomCtrl.text,
      prenom: _prenomCtrl.text,
      email: _emailCtrl.text,
      password: _passCtrl.text,
      classeId: selectedClasse!.id,
    );
    try {
      if (isEdit) {
        await EtudiantService().updateEtudiant(etu);
      } else {
        await EtudiantService().createEtudiant(etu);
      }
      widget.onSuccess();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? "Modifier étudiant" : "Ajouter un étudiant"),
      content: isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nomCtrl,
                    decoration: const InputDecoration(
                      labelText: "Nom",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _prenomCtrl,
                    decoration: const InputDecoration(
                      labelText: "Prénom",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (!isEdit) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passCtrl,
                      decoration: const InputDecoration(
                        labelText: "Mot de passe",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                  ],
                  const SizedBox(height: 16),
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
          child: Text(isEdit ? "Modifier" : "Enregistrer"),
        ),
      ],
    );
  }
}
