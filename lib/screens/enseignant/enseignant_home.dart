import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/screens/enseignant/mes_seances_screen.dart';
import 'package:gest_absence_frontend/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnseignantHome extends StatefulWidget {
  const EnseignantHome({super.key});

  @override
  State<EnseignantHome> createState() => _EnseignantHomeState();
}

class _EnseignantHomeState extends State<EnseignantHome> {
  Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove("user_id");
    await pref.remove("role");

    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ListTile(
          leading: Icon(Icons.school_outlined),
          title: Text("GestAbsence"),
        ),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: MesSeancesScreen(),
    );
  }
}
