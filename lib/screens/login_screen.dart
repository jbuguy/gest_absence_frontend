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

  // Couleur principale teal
  static const _teal = Color(0xFF0F9B8E);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
          break;
        default:
          _showError("Rôle inconnu");
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
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF0D3D38),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Le logo SVG : registre avec checkmark
  Widget _buildLogo() {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: _teal,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _teal.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(50, 50),
          painter: _LogoPainter(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeMode == ThemeMode.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bouton toggle thème en haut à droite
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: _teal,
                      size: 20,
                    ),
                    onPressed: widget.onToggleTheme,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Logo + nom + tagline centrés
              Center(
                child: Column(
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 14),
                    Text(
                      "GestAbsence",
                      style: GoogleFonts.manrope(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Suivi des présences · FSB",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _teal.withOpacity(0.7),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Label email
              Text(
                "EMAIL PROFESSIONNEL",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _teal,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 7),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined, color: _teal, size: 20),
                  hintText: "prenom.nom@fsb.ucar.tn",
                ),
              ),

              const SizedBox(height: 18),

              // Label mot de passe
              Text(
                "MOT DE PASSE",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _teal,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 7),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outlined, color: _teal, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: _teal.withOpacity(0.5),
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              // Rester connecté
              Row(
                children: [
                  Checkbox(
                    value: _stayConnected,
                    activeColor: _teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (v) =>
                        setState(() => _stayConnected = v ?? false),
                  ),
                  Text(
                    "Rester connecté",
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Bouton connexion
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _login,
                  style: FilledButton.styleFrom(
                    backgroundColor: _teal,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text(
                    "Se connecter",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Painter pour le logo registre + checkmark
class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    // Registre (rectangle arrondi)
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.05,
          size.width * 0.58, size.height * 0.82),
      const Radius.circular(5),
    );
    canvas.drawRRect(rect, fillPaint);
    canvas.drawRRect(rect, paint);

    // Lignes du registre
    final lineX1 = size.width * 0.22;
    final lineX2 = size.width * 0.58;
    canvas.drawLine(Offset(lineX1, size.height * 0.32),
        Offset(lineX2, size.height * 0.32), paint);
    canvas.drawLine(Offset(lineX1, size.height * 0.48),
        Offset(lineX2, size.height * 0.48), paint);
    canvas.drawLine(Offset(lineX1, size.height * 0.64),
        Offset(size.width * 0.46, size.height * 0.64), paint);

    // Cercle badge checkmark
    final circlePaint = Paint()
      ..color = const Color(0xFF0F9B8E)
      ..style = PaintingStyle.fill;
    final circleBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final center = Offset(size.width * 0.76, size.height * 0.72);
    canvas.drawCircle(center, size.width * 0.2, circlePaint);
    canvas.drawCircle(center, size.width * 0.2, circleBorderPaint);

    // Checkmark
    final checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(center.dx - size.width * 0.1, center.dy)
      ..lineTo(center.dx - size.width * 0.02, center.dy + size.height * 0.08)
      ..lineTo(center.dx + size.width * 0.12, center.dy - size.height * 0.08);
    canvas.drawPath(path, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}