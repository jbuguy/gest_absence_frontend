import 'package:flutter/material.dart';
// Importez votre écran AdminHome
import 'package:gest_absence_frontend/screens/admin/admin_home.dart';

void main() {
  runApp(const MyApp());
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