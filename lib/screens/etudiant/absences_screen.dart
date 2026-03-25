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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(),
        Row(
          children: [
            const Text("Detail par matiere"),
            Text(DateFormat("d MMMM", "fr_FR").format(DateTime.now())),
          ],
        ),

        Expanded(
          child: FutureBuilder(
            future: futureAbsences,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("no absence found"));
              }
              final absences = snapshot.data!;
              return ListView.builder(
                itemCount: absences.length,
                itemBuilder: (context, index) {
                  final absence = absences[index];
                  return ListTile(
                    title: Text(absence.nomMatiere),
                    subtitle: Text(
                      "${absence.dateSeance} - ${absence.heureDebut}",
                    ),
                    trailing: Text(
                      absence.statut,
                      style: TextStyle(
                        color: absence.statut.toLowerCase() == "present"
                            ? Colors.green
                            : Colors.red,
                        fontWeight: .bold,
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
