import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/enseignant.dart';
import 'package:gest_absence_frontend/services/enseignant_service.dart';

class EnseignantsScreen extends StatefulWidget {
  const EnseignantsScreen({super.key});

  @override
  State<EnseignantsScreen> createState() => _EnseignantsScreenState();
}

class _EnseignantsScreenState extends State<EnseignantsScreen> {
  late Future<List<Enseignant>> futureEnseignants;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      futureEnseignants = EnseignantService().getEnseignants();
    });
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
                "Enseignants",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              FilledButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) =>
                      EnseignantDetailDialog(onSuccess: _refresh),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Ajouter"),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Enseignant>>(
            future: futureEnseignants,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Erreur: ${snapshot.error}"));
              }
              final enseignants = snapshot.data ?? [];
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: enseignants.length,
                itemBuilder: (context, index) {
                  final ens = enseignants[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor:
                            colorScheme.primary.withValues(alpha: 0.12),
                        child: Text(
                          ens.prenom.isNotEmpty ? ens.prenom[0].toUpperCase() : "?",
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        "${ens.prenom} ${ens.nom}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(ens.specialite ?? "Sans spécialité"),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: colorScheme.primary,
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => EnseignantDetailDialog(
                            enseignant: ens,
                            onSuccess: _refresh,
                          ),
                        ),
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

class EnseignantDetailDialog extends StatefulWidget {
  final Enseignant? enseignant;
  final VoidCallback onSuccess;

  const EnseignantDetailDialog(
      {super.key, this.enseignant, required this.onSuccess});

  @override
  State<EnseignantDetailDialog> createState() =>
      _EnseignantDetailDialogState();
}

class _EnseignantDetailDialogState extends State<EnseignantDetailDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _specCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.enseignant != null) {
      _nomCtrl.text = widget.enseignant!.nom;
      _prenomCtrl.text = widget.enseignant!.prenom;
      _emailCtrl.text = widget.enseignant!.email ?? "";
      _specCtrl.text = widget.enseignant!.specialite ?? "";
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ens = Enseignant(
      userId: widget.enseignant?.userId,
      nom: _nomCtrl.text,
      prenom: _prenomCtrl.text,
      email: _emailCtrl.text,
      specialite: _specCtrl.text,
      matiereId: 1,
    );
    try {
      if (widget.enseignant == null) {
        await EnseignantService().createEnseignant(ens, _passCtrl.text);
      } else {
        await EnseignantService().updateEnseignant(ens);
      }
      widget.onSuccess();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur serveur: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.enseignant == null
          ? "Nouvel enseignant"
          : "Modifier enseignant"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(
                  labelText: "Nom",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Champ requis" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _prenomCtrl,
                decoration: const InputDecoration(
                  labelText: "Prénom",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Champ requis" : null,
              ),
              if (widget.enseignant == null) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? "Champ requis" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passCtrl,
                  decoration: const InputDecoration(
                    labelText: "Mot de passe",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (v) => v!.isEmpty ? "Champ requis" : null,
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _specCtrl,
                decoration: const InputDecoration(
                  labelText: "Spécialité",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Champ requis" : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text("Enregistrer"),
        ),
      ],
    );
  }
}