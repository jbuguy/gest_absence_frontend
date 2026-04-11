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
    futureEnseignants = EnseignantService().getEnseignants();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureEnseignants,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Aucun enseignant trouvé"));
        }
        final enseignants = snapshot.data!;
        return ListView.builder(
          itemCount: enseignants.length,
          itemBuilder: (context, index) {
            final enseignant = enseignants[index];
            return ListTile(
              title: Text("${enseignant.prenom} ${enseignant.nom}"),
              subtitle: Text("ID: ${enseignant.id}"),
            );
          },
        );
      },
    );
  }
}
