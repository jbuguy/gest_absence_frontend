import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/models/utilisateur.dart';
import 'package:gest_absence_frontend/screens/admin/admin_home.dart';
import 'package:gest_absence_frontend/screens/enseignant/enseignant_home.dart';
import 'package:gest_absence_frontend/screens/etudiant/etudiant_home.dart';
import 'package:gest_absence_frontend/screens/login_screen.dart';

Widget getHomeScreenByRole(
  Role role, {
  required ThemeMode themeMode,
  required VoidCallback onToggleTheme,
}) {
  switch (role) {
    case .etudiant:
      return EtudiantHomeScreen(
        themeMode: themeMode,
        onToggleTheme: onToggleTheme,
      );
    case .enseignant:
      return EnseignantHome(themeMode: themeMode, onToggleTheme: onToggleTheme);
    case .admin:
      return AdminHome(themeMode: themeMode, onToggleTheme: onToggleTheme);
    default:
      return LoginScreen(themeMode: themeMode, onToggleTheme: onToggleTheme);
  }
}
