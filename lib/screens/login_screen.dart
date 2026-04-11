import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gest_absence_frontend/screens/etudiant/etudiant_home.dart';
import 'package:gest_absence_frontend/screens/admin/admin_home.dart';
import 'package:gest_absence_frontend/screens/enseignant/enseignant_home.dart';
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
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("user_id", user["id"]);
      await prefs.setString("role", user["role"]);

      if (!mounted) return;

      Widget screen;
      switch (user["role"]) {
        case "etudiant":
          screen = EtudiantHomeScreen();
          break;
        case "admin":
          screen = AdminHome();
          break;
        case "enseignant":
          screen = EnseignantHome();
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.school,
                    color: Theme.of(context).primaryColor,
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "GestAbsence",
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Text(
                "Bienvenue sur GestAbsence",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Veuillez entrer vos identifiants pour accéder au tableau de bord.",
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 40),
              const Text(
                "email professionnel",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: "prenom.nom@fsb.ucar.tn",
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "mot de passe",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outlined),
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
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _login,
                  label: const Text("connecter"),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
