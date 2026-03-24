import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/config/app_theme.dart';
import 'package:gest_absence_frontend/screens/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);

  runApp(
    MaterialApp(
      title: "gestAbsence",
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GestAbsence",
      debugShowCheckedModeBanner: false,
      // Activation obligatoire du Material Design 3 selon le sujet
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      // On affiche directement AdminHome pour vos tests locaux
      home: AdminHome(), 
    );
  }
}