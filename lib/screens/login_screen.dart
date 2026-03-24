import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/screens/etudiant_home.dart';
import 'package:gest_absence_frontend/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _stayConnected = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> _login() async {
    try {
      final res = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (res["success"] == 0) {
        _showError(res["message"]);
        return;
      }
      final user = res["user"];
      print("User: $user");

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("user_id", user["user_id"]);
      await prefs.setString("role", user["role"]);

      if (!mounted) return;

      Widget screen;
      switch (user["role"]) {
        case "etudiant":
          screen = EtudiantHomeScreen();
          break;
        default:
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("unknown role")));
          return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.school_outlined),
                title: Text("GestAbsence"),
              ),
              Text(
                "Veuillez entrer vos identifiants pour accéder au tableau de bord.",
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: "email professionnel",
                  hintText: "prenom.nom@fsb.ucar.tn",
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outlined),
                  labelText: "mot de passe",
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _stayConnected,
                    onChanged: (value) =>
                        setState(() => _stayConnected = value ?? false),
                  ),
                  const Text("Rester connecte"),
                ],
              ),
              FilledButton(
                onPressed: _login,
                child: Row(
                  children: [
                    Text("connecter"),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
