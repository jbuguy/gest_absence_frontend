import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/screens/home_app_bar.dart';
import 'etudiants_screen.dart';
import 'enseignants_screen.dart';
import 'classes_screen.dart';
import 'seances_screen.dart';
import 'dashboard.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      AdminDashboardContent(
        onNavigate: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      const EtudiantsScreen(),
      const EnseignantsScreen(),
      const ClassesScreen(),
      const SeancesScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: HomeAppBar(),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.12),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.dashboard_outlined,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            selectedIcon: Icon(
              Icons.dashboard,
              color: theme.colorScheme.primary,
            ),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.school_outlined,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            selectedIcon: Icon(
              Icons.school,
              color: theme.colorScheme.primary,
            ),
            label: 'Étudiants',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            selectedIcon: Icon(
              Icons.person,
              color: theme.colorScheme.primary,
            ),
            label: 'Enseignants',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.class_outlined,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            selectedIcon: Icon(
              Icons.class_,
              color: theme.colorScheme.primary,
            ),
            label: 'Classes',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.calendar_today_outlined,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            selectedIcon: Icon(
              Icons.calendar_today,
              color: theme.colorScheme.primary,
            ),
            label: 'Séances',
          ),
        ],
      ),
    );
  }
}