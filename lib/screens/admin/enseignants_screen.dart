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
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion des Enseignants")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => EnseignantDetailDialog(onSuccess: _refresh),
        ),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Enseignant>>(
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
            itemCount: enseignants.length,
            itemBuilder: (context, index) {
              final ens = enseignants[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.school)),
                title: Text("${ens.prenom} ${ens.nom}"),
                subtitle: Text(ens.specialite ?? "Sans spécialité"),
                trailing: const Icon(Icons.edit, color: Colors.blue),
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => EnseignantDetailDialog(
                    enseignant: ens,
                    onSuccess: _refresh,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// --- LE DIALOGUE DE FORMULAIRE (INCLUS DANS LE MÊME FICHIER) ---

class EnseignantDetailDialog extends StatefulWidget {
  final Enseignant? enseignant;
  final VoidCallback onSuccess;

  const EnseignantDetailDialog({super.key, this.enseignant, required this.onSuccess});

  @override
  State<EnseignantDetailDialog> createState() => _EnseignantDetailDialogState();
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
      userId: widget.enseignant?.userId, // Utilise l'ID existant pour l'UPDATE
      nom: _nomCtrl.text,
      prenom: _prenomCtrl.text,
      email: _emailCtrl.text,
      specialite: _specCtrl.text,
      matiereId: 1, // Requis par ton PHP pour le PUT
    );

    try {
      if (widget.enseignant == null) {
        // AJOUT : nécessite un mot de passe
        await EnseignantService().createEnseignant(ens, _passCtrl.text);
      } else {
        // MODIFICATION
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
      title: Text(widget.enseignant == null ? "Nouvel Enseignant" : "Modifier Enseignant"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(labelText: "Nom"),
                validator: (v) => v!.isEmpty ? "Champ requis" : null,
              ),
              TextFormField(
                controller: _prenomCtrl,
                decoration: const InputDecoration(labelText: "Prénom"),
                validator: (v) => v!.isEmpty ? "Champ requis" : null,
              ),
              if (widget.enseignant == null) ...[
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (v) => v!.isEmpty ? "Champ requis" : null,
                ),
                TextFormField(
                  controller: _passCtrl,
                  decoration: const InputDecoration(labelText: "Mot de passe"),
                  obscureText: true,
                  validator: (v) => v!.isEmpty ? "Champ requis" : null,
                ),
              ],
              TextFormField(
                controller: _specCtrl,
                decoration: const InputDecoration(labelText: "Spécialité"),
                validator: (v) => v!.isEmpty ? "Champ requis" : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
        ElevatedButton(onPressed: _submit, child: const Text("Enregistrer")),
      ],
    );
  }
}