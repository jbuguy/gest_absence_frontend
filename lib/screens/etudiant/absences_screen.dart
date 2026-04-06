import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/absence.dart';
import 'package:gest_absence_frontend/services/absence_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbsencesScreen extends StatefulWidget {
  const AbsencesScreen({super.key});

  @override
  State<AbsencesScreen> createState() => _AbsencesScreenState();
}

class _AbsencesScreenState extends State<AbsencesScreen> {
  late Future<List<Absence>> futureAbsences;
  
  @override
  void initState() {
    super.initState();
    futureAbsences = _loadAbsences();
  }

  Future<List<Absence>> _loadAbsences() async {
    final prefrences = await SharedPreferences.getInstance();
    final userId = prefrences.getInt("user_id");
    if (userId == null) {
      throw Exception("User not logged in ");
    }
    final service = AbsenceService();
    return service.getAbsences(userId);
  }

  Future<void> _refreshData() async {
    setState(() {
      futureAbsences = _loadAbsences();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder(
      future: futureAbsences,
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        final absences = snapshot.data ?? [];
        final totalAbsences = absences
            .where((a) => a.statut.toLowerCase() == "absent")
            .length;
        return RefreshIndicator(
          onRefresh: _refreshData,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TopCard(total: totalAbsences),
                ),
              ),
              if (totalAbsences > 0)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Detail par matiere",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat("d MMMM", "fr_FR").format(DateTime.now()),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (totalAbsences == 0)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyAbsenceState(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => AbsenceTile(absence: absences[index]),
                      childCount: absences.length,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        );
      },
    );
  }
}

class AbsenceTile extends StatelessWidget {
  const AbsenceTile({super.key, required this.absence});

  final Absence absence;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPresent = absence.statut.toLowerCase() == "present";

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 8,
        ),
        title: Text(
          absence.nomMatiere,
          style: const TextStyle(fontWeight: .bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text("${absence.dateSeance} - ${absence.heureDebut}"),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isPresent
                ? Colors.green.withValues(alpha: 0.1)
                : theme.colorScheme.errorContainer.withValues(alpha: 0.5),
            borderRadius: .circular(12),
          ),
          child: Text(
            absence.statut.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: isPresent ? Colors.green : theme.colorScheme.error,
              fontWeight: .bold,
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyAbsenceState extends StatelessWidget {
  const EmptyAbsenceState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: .center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
            shape: .circle,
          ),
          child: Icon(
            Icons.workspace_premium,
            size: 64,
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Felicitations",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: .w900,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Text(
            "Vous n'avez aucune absence enregistrée pour cette année universitaire. Continuez ainsi !",
            textAlign: .center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class TopCard extends StatelessWidget {
  const TopCard({super.key, required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.primary,
      ),
      child: Column(
        children: [
          Text(
            "ANNEE UNIVERSITAIRE 2025-2026",
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.8),
              fontWeight: .bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "$total",
            style: theme.textTheme.displayLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: .w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Total des absences",
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: .w600,
            ),
          ),
        ],
      ),
    );
  }
}
