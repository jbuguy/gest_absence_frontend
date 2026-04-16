import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/screens/home_app_bar.dart';
import 'package:gest_absence_frontend/screens/enseignant/mes_seances_screen.dart';

class EnseignantHome extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const EnseignantHome({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<EnseignantHome> createState() => _EnseignantHomeState();
}

class _EnseignantHomeState extends State<EnseignantHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        themeMode: widget.themeMode,
        onToggleTheme: widget.onToggleTheme,
      ),
      body: MesSeancesScreen(),
    );
  }
}
