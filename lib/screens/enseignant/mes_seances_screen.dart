import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/seance.dart';
import 'package:gest_absence_frontend/screens/enseignant/appel_screen.dart';
import 'package:gest_absence_frontend/services/auth_service.dart';
import 'package:gest_absence_frontend/services/seance_service.dart';
import 'package:intl/intl.dart';

class MesSeancesScreen extends StatefulWidget {
  const MesSeancesScreen({super.key});

  @override
  State<MesSeancesScreen> createState() => _MesSeancesScreenState();
}

class SeanceCard extends StatelessWidget {
  final Seance seance;
  const SeanceCard({super.key, required this.seance});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              seance.classeNom,
              style: theme.textTheme.labelLarge?.copyWith(fontWeight: .w500),
            ),
            const SizedBox(height: 8.0),
            Text(
              seance.matiere,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: .w900),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.schedule),
                const SizedBox(width: 4.0),
                Text("${seance.heureDebut} - ${seance.heureFin} "),
              ],
            ),
            const SizedBox(height: 8.0),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppelScreen(seance: seance),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  const Icon(Icons.assignment_add),
                  const SizedBox(width: 4.0),
                  Text(
                    "Faire l'appel",
                    style: theme.primaryTextTheme.bodyMedium?.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MesSeancesScreenState extends State<MesSeancesScreen> {
  late Future<List<Seance>> futureSeances;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return FutureBuilder(
      future: futureSeances,
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        final seances = snapshot.data ?? [];
        final aujourdhui = DateFormat("d MMMM", "fr_FR").format(DateTime.now());
        return RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "aujourd'hui, $aujourdhui".toUpperCase(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Mes Seances",
                    style: theme.primaryTextTheme.headlineLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Planning du jour",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: seances
                        .map((seance) => SeanceCard(seance: seance))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    futureSeances = _loadSeances();
  }

  Future<void> _refreshData() async {
    setState(() {
      futureSeances = _loadSeances();
    });
  }

  Future<List<Seance>> _loadSeances() async {
    final user = await AuthService().getCurrentUser();
    final userId = user?.id;
    if (userId == null) {
      throw Exception("User not logged in ");
    }
    final service = SeanceService();
    return service.getSeanceTeacher(userId);
  }
}
