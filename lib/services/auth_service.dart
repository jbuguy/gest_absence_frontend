import 'package:gest_absence_frontend/config/api_config.dart';
import 'package:gest_absence_frontend/models/login_response.dart';
import 'package:gest_absence_frontend/models/utilisateur.dart';
import 'package:gest_absence_frontend/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiService _api = ApiService();
  Future<LoginResponse> login(
    String email,
    String password,
    bool rememberMe,
  ) async {
    final response = await _api.post(ApiConfig.login, {
      "email": email,
      "password": password,
    });

    final loginResponse = LoginResponse.fromJson(response);

    if (loginResponse.success && loginResponse.user != null) {
      final user = loginResponse.user!;
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool("remember_me", rememberMe);

      await prefs.setInt("user_id", user.id);
      await prefs.setString("role", user.role);
      await prefs.setString("nom", user.nom);
      await prefs.setString("prenom", user.prenom);
    }
    return loginResponse;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }

  Future<(bool, Utilisateur?)> getSession() async {
    final prefs = await SharedPreferences.getInstance();

    final rememberMe = prefs.getBool("remember_me") ?? false;

    if (!rememberMe) {
      await prefs.clear();
      return (false, null);
    }

    final role = prefs.getString("role") ?? "";
    final nom = prefs.getString("nom") ?? "";
    final prenom = prefs.getString("prenom") ?? "";
    final id = prefs.getInt("user_id") ?? -1;
    return (true, Utilisateur(id: id, nom: nom, prenom: prenom, role: role));
  }
}
