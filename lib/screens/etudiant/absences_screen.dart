import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/absence.dart';
import 'package:gest_absence_frontend/services/absence_service.dart';
import 'package:gest_absence_frontend/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
    final user = await AuthService().getCurrentUser();
    final userId = user?.id;
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
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        TopCard(total: totalAbsences),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () async {
                            final absences = snapshot.data ?? [];
                            await generatePdf(absences);
                          },
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text("Générer PDF"),
                        ),
                      ],
                    ),
                  ),
                  if (totalAbsences > 0)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 24, 8, 16),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text(
                            "Detail par matiere",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat(
                              "d MMMM",
                              "fr_FR",
                            ).format(DateTime.now()),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (totalAbsences == 0)
                    const SizedBox(height: 400, child: EmptyAbsenceState())
                  else
                    Column(
                      children: [
                        for (var absence in absences)
                          AbsenceTile(absence: absence),
                      ],
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> generatePdf(List<Absence> absences) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Rapport des Absences",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text("Année universitaire 2025-2026"),
              pw.SizedBox(height: 16),

              pw.TableHelper.fromTextArray(
                headers: ["Matière", "Date", "Heure", "Statut"],
                data: absences.map((a) {
                  return [a.nomMatiere, a.dateSeance, a.heureDebut, a.statut];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
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
      width: .infinity,
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
