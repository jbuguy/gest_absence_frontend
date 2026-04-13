import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gest_absence_frontend/screens/etudiant/etudiant_home.dart';
import 'package:gest_absence_frontend/screens/admin/admin_home.dart';
import 'package:gest_absence_frontend/screens/enseignant/enseignant_home.dart';
import 'package:gest_absence_frontend/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const LoginScreen({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _stayConnected = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //             on accède aux champs via widget.themeMode et widget.onToggleTheme
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

      // ✅ ÉTAPE 3 : on transmet themeMode et onToggleTheme à chaque écran
      Widget screen;
      switch (user["role"]) {
        case "etudiant":
          screen = EtudiantHomeScreen(
            themeMode: widget.themeMode,
            onToggleTheme: widget.onToggleTheme,
          );
          break;
        case "admin":
          screen = AdminHome(
            themeMode: widget.themeMode,
            onToggleTheme: widget.onToggleTheme,
          );
          break;
        case "enseignant":
          screen = EnseignantHome(
            themeMode: widget.themeMode,
            onToggleTheme: widget.onToggleTheme,
          );
          break; // ✅ break manquant corrigé
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Rôle inconnu")),
          );
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const Text(
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
                "Email professionnel",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: "prenom.nom@fsb.ucar.tn",
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Mot de passe",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outlined),
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
                  const Text("Rester connecté"),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  // ✅ plus de paramètres ici, _login() les prend via widget.*
                  onPressed: _login,
                  label: const Text("Se connecter"),
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