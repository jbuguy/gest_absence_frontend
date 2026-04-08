import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/seance.dart';
import 'package:gest_absence_frontend/screens/enseignant/appel_screen.dart';
import 'package:gest_absence_frontend/services/seance_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          Text(seance.matiere),
          Row(
            children: [
              Icon(Icons.lock_clock),
              Text("${seance.heureDebut} - ${seance.heureFin} "),
            ],
          ),
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppelScreen(id: seance.id),
                ),
              );
            },
            child: const Row(
              children: [Icon(Icons.assignment_add), Text("Faire l'appel")],
            ),
          ),
        ],
      ),
    );
  }
}

class _MesSeancesScreenState extends State<MesSeancesScreen> {
  late Future<List<Seance>> futureSeances;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Text("aujourdhui $aujourdhui"),
                    const SizedBox(height: 8),
                    const Text("Planning du jour"),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => SeanceCard(seance: seances[index]),
                  childCount: seances.length,
                ),
              ),
            ],
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
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("user_id");
    if (userId == null) {
      throw Exception("User not logged in ");
    }
    final service = SeanceService();
    return service.getSeanceTeacher(userId);
  }
}
