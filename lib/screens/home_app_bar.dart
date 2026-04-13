import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  // ✅ ajouter les deux champs
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const HomeAppBar({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  Future<void> logout(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove("user_id");
    await pref.remove("role");

    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          themeMode: themeMode,
          onToggleTheme: onToggleTheme,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 10,
      title: ListTile(
        leading: Icon(
          Icons.school,
          color: Theme.of(context).primaryColor,
          size: 16,
        ),
        title: const Text("GestAbsence"),
      ),
      actions: [
        // ✅ bouton toggle thème
        IconButton(
          icon: Icon(
            themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          tooltip: themeMode == ThemeMode.dark ? 'Mode clair' : 'Mode sombre',
          onPressed: onToggleTheme,
        ),
        IconButton(
          onPressed: () => logout(context),
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}