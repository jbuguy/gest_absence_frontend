import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/screens/etudiant/absences_screen.dart';
import 'package:gest_absence_frontend/screens/etudiant/profil_screen.dart';
import 'package:gest_absence_frontend/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EtudiantHomeScreen extends StatefulWidget {
  const EtudiantHomeScreen({super.key});

  @override
  State<EtudiantHomeScreen> createState() => _EtudiantHomeScreenState();
}

class _EtudiantHomeScreenState extends State<EtudiantHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [const AbsencesScreen(), const ProfilScreen()];

  Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove("user_id");
    await pref.remove("role");

    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: Icon(Icons.school_outlined),
          title: Text("GestAbsence"),
        ),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
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
