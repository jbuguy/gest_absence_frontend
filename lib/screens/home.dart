import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/screens/admin/admin_home.dart';
import 'package:gest_absence_frontend/screens/enseignant/enseignant_home.dart';
import 'package:gest_absence_frontend/screens/etudiant/etudiant_home.dart';
import 'package:gest_absence_frontend/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  // ✅ ajouter les deux champs
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const Home({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<String?> futureRole;

  @override
  void initState() {
    super.initState();
    futureRole = _loadRole();
  }

  Future<String?> _loadRole() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("role");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureRole,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final role = snapshot.data;

        // ✅ plus de const — on transmet themeMode et onToggleTheme
        switch (role) {
          case "etudiant":
            return EtudiantHomeScreen(
              themeMode: widget.themeMode,
              onToggleTheme: widget.onToggleTheme,
            );
          case "enseignant":
            return EnseignantHome(
              themeMode: widget.themeMode,
              onToggleTheme: widget.onToggleTheme,
            );
          case "admin":
            return AdminHome(
              themeMode: widget.themeMode,
              onToggleTheme: widget.onToggleTheme,
            );
          default:
            return LoginScreen(
              themeMode: widget.themeMode,
              onToggleTheme: widget.onToggleTheme,
            );
        }
      },
    );
  }
}