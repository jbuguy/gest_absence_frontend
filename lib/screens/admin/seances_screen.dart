import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/seance.dart';
import 'package:gest_absence_frontend/services/seance_service.dart';

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
    futureSeances = SeanceService().getSeancesAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion Séances")),
      body: FutureBuilder<List<Seance>>(
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
            itemCount: seances.length,
            itemBuilder: (context, index) {
              final seance = seances[index];
              return ListTile(
                title: Text(seance.matiere),
                subtitle: Text(
                  "${seance.date} - ${seance.heureDebut} à ${seance.heureFin}",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
