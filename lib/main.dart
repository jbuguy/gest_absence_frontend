import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/config/app_theme.dart';
import 'package:gest_absence_frontend/screens/admin/admin_home.dart';
import 'package:gest_absence_frontend/screens/enseignant/enseignant_home.dart';
import 'package:gest_absence_frontend/screens/etudiant/etudiant_home.dart';
import 'package:gest_absence_frontend/screens/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "gestAbsence",
      theme: AppTheme.lightTheme,
      home: const Root(),
    );
  }
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late Future<bool> futureAuthSession;

  @override
  void initState() {
    super.initState();
    futureAuthSession = _getAuthSession();
  }

  Future<bool> _getAuthSession() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool("session") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureAuthSession,
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final activeSession = snapshot.data ?? false;
        return activeSession ? const Home() : const LoginScreen();
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

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
        if (snapshot.connectionState == .waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final role = snapshot.data;
        switch (role) {
          case "etudiant":
            return const EtudiantHomeScreen();
          case "enseignant":
            return const EnseignantHome();
          case "admin":
            return const AdminHome();
          default:
            return const LoginScreen();
        }
      },
    );
  }
}
