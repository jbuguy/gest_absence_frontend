import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/screens/home_app_bar.dart';
import 'etudiants_screen.dart';
import 'enseignants_screen.dart';
import 'classes_screen.dart';
import 'seances_screen.dart';
import 'dashboard.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      AdminDashboardContent(
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
      appBar: HomeAppBar(),
      body: screens[_selectedIndex],
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
