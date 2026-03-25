import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/classe.dart';
import 'package:gest_absence_frontend/services/classe_service.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  Future<List<Classe>> _loadClasses() async {
    return ClasseService().getClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion Classes")),
      body: FutureBuilder<List<Classe>>(
        future: _loadClasses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classe = classes[index];
              return ListTile(
                title: Text(classe.nom),
                subtitle: Text("Niveau: ${classe.niveau}"),
              );
            },
          );
        },
      ),
    );
  }
}
