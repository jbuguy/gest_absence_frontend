import 'package:flutter/material.dart';
import 'etudiants_screen.dart';
import 'enseignants_screen.dart';
import 'classes_screen.dart';
import 'seances_screen.dart';
import 'dashboard.dart';
import 'package:gest_absence_frontend/services/admin_service.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;

  final AdminService _adminService = AdminService();

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
      final data = await _adminService.getStats();
      setState(() {
        stats = {
          "total_etudiants": data['total_etudiants'].toString(),
          "total_enseignants": data['total_enseignants'].toString(),
          "absences_jour": data['absences_jour'].toString(),
        };
        isLoading = false;
      });
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
