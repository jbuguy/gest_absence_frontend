import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/screens/login_screen.dart';

void main() {
  runApp(
    MaterialApp(
      title: "gestAbsence",
      theme: ThemeData(useMaterial3: true),
      home: const LoginScreen(),
    ),
  );
}
