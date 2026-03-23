import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/config/app_theme.dart';
import 'package:gest_absence_frontend/screens/login_screen.dart';

void main() {
  runApp(
    MaterialApp(
      title: "gestAbsence",
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    ),
  );
}
