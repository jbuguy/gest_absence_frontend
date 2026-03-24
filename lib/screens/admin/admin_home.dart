import 'package:flutter/material.dart';
import 'etudiants_screen.dart';
import 'enseignants_screen.dart';
import 'classes_screen.dart';
import 'seances_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;

  // Initialisation des stats avec des valeurs par défaut
  Map<String, dynamic> stats = {
    "total_etudiants": "0",
    "total_enseignants": "0",
    "absences_jour": "0",
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/gest_absence_api/admin/stats.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          stats = {
            "total_etudiants": data['total_etudiants'].toString(),
            "total_enseignants": data['total_enseignants'].toString(),
            "absences_jour": data['absences_jour'].toString(),
          };
          isLoading = false;
        });
      }
    } catch (e) {
      print("Erreur stats: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // On prépare la liste des écrans ici pour pouvoir passer les stats au Dashboard
    final List<Widget> _screens = [
      AdminDashboardContent(
        stats: stats, // On passe les données réelles ici
        onNavigate: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      const EtudiantsScreen(),
      const EnseignantsScreen(),
      const ClassesScreen(),
      const SeancesScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(icon: Icon(Icons.school), label: 'Étudiants'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Enseignants'),
          NavigationDestination(icon: Icon(Icons.class_), label: 'Classes'),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Séances',
          ),
        ],
      ),
    );
  }
}

class AdminDashboardContent extends StatelessWidget {
  final Function(int)? onNavigate;
  final Map<String, dynamic> stats; // Ajout pour recevoir les stats

  const AdminDashboardContent({
    super.key,
    this.onNavigate,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ADMINISTRATION",
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      "Bonjour, M. Dupont",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.orange[100],
                  child: const Icon(Icons.person, color: Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () => onNavigate?.call(4),
              icon: const Icon(Icons.add),
              label: const Text("Nouvelle Séance"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // UTILISATION DES DONNÉES RÉELLES ICI
            _buildStatCard(
              "Total Étudiants",
              stats['total_etudiants'],
              Icons.group,
              Colors.blue,
              null,
            ),
            _buildStatCard(
              "Enseignants",
              stats['total_enseignants'],
              Icons.school,
              Colors.orange,
              null,
            ),
            _buildStatCard(
              "Absences du jour",
              stats['absences_jour'],
              Icons.warning,
              Colors.red,
              null,
            ),

            const SizedBox(height: 30),
            const Text(
              "Accès Rapide",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            _buildQuickAccessItem(
              context,
              "Gestion Étudiants",
              "Inscriptions, Profils, Listes",
              Icons.person_add,
              () => onNavigate?.call(1),
            ),
            _buildQuickAccessItem(
              context,
              "Gestion Enseignants",
              "Planning, Affectations",
              Icons.assignment_ind,
              () => onNavigate?.call(2),
            ),
            _buildQuickAccessItem(
              context,
              "Planning des Séances",
              "Calendrier académique",
              Icons.calendar_month,
              () => onNavigate?.call(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String? trend,
  ) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600])),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

