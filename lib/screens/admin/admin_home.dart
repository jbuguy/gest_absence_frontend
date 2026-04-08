import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      appBar: AppBar(
        title: const ListTile(
          leading: Icon(Icons.school_outlined),
          title: Text("GestAbsence"),
        ),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),
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
