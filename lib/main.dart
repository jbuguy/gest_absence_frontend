import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/config/app_theme.dart';
import 'package:gest_absence_frontend/screens/home.dart';
import 'package:gest_absence_frontend/screens/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
    ThemeMode _themeMode = ThemeMode.light; // ← le state du thème
    void _toggleTheme() {                  // ← la fonction qui change le thème
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: "gestAbsence",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,     // ← tu dois créer ça dans app_theme.dart
      themeMode: _themeMode,
      home: Root(themeMode: _themeMode,           // ← ENVOIE vers Root
        onToggleTheme: _toggleTheme,),
    );
  }
}

class Root extends StatefulWidget {
  final ThemeMode themeMode;         // ← REÇOIT
  final VoidCallback onToggleTheme; 
  const Root({super.key,required this.themeMode,
    required this.onToggleTheme,});

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
        return activeSession ? Home(                              // ← RETRANSMET
                themeMode: widget.themeMode,
                onToggleTheme: widget.onToggleTheme,
              )
            : LoginScreen(                       // ← RETRANSMET
                themeMode: widget.themeMode,
                onToggleTheme: widget.onToggleTheme,
              );
      },
    );
  }
}
