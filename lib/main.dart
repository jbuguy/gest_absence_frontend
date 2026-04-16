import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/config/app_theme.dart';
import 'package:gest_absence_frontend/models/utilisateur.dart';
import 'package:gest_absence_frontend/screens/login_screen.dart';
import 'package:gest_absence_frontend/services/auth_service.dart';
import 'package:gest_absence_frontend/utils/navigation_utils.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  ThemeMode _theme = ThemeMode.light;
  late Future<(bool, Utilisateur?)> futureAuthSession;

  @override
  void initState() {
    super.initState();
    final service = AuthService();
    futureAuthSession = service.getSession();
  }

  void _toggleTheme() => setState(() {
    _theme = _theme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "gestAbsence",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _theme,
      home: FutureBuilder(
        future: futureAuthSession,
        builder: (context, snapshot) {
          if (snapshot.connectionState == .waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (!snapshot.hasData) {
            return LoginScreen(themeMode: _theme, onToggleTheme: _toggleTheme);
          }
          final (activeSession, user) = snapshot.data!;
          return activeSession
              ? getHomeScreenByRole(
                  user!.role,
                  themeMode: _theme,
                  onToggleTheme: _toggleTheme,
                )
              : LoginScreen(themeMode: _theme, onToggleTheme: _toggleTheme);
        },
      ),
    );
  }
}
