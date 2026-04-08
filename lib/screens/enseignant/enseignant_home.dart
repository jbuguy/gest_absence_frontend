import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/screens/etudiant/absences_screen.dart';
import 'package:gest_absence_frontend/screens/etudiant/profil_screen.dart';

class EnseignantHome extends StatefulWidget {
  const EnseignantHome({super.key});

  @override
  State<EnseignantHome> createState() => _EnseignantHomeState();
}

class _EnseignantHomeState extends State<EnseignantHome> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [const AbsencesScreen(), const ProfilScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ListTile(
          leading: Icon(Icons.school_outlined),
          title: Text("GestAbsence"),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: "mes seance",
          ),
          NavigationDestination(icon: Icon(Icons.dashboard), label: "Profil"),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
    );
  }
}
