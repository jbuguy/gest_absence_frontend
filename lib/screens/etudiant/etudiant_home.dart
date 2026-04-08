import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/screens/etudiant/absences_screen.dart';
import 'package:gest_absence_frontend/screens/etudiant/profil_screen.dart';
import 'package:gest_absence_frontend/screens/home_app_bar.dart';

class EtudiantHomeScreen extends StatefulWidget {
  const EtudiantHomeScreen({super.key});

  @override
  State<EtudiantHomeScreen> createState() => _EtudiantHomeScreenState();
}

class _EtudiantHomeScreenState extends State<EtudiantHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [const AbsencesScreen(), const ProfilScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
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
          NavigationDestination(icon: Icon(Icons.person), label: 'profil'),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
    );
  }
}
