import 'package:gest_absence_frontend/config/api_config.dart';
import 'package:gest_absence_frontend/services/api_service.dart';

class AuthService {
  final ApiService _api = ApiService();
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _api.post(ApiConfig.login, {
      "email": email,
      "password": password,
    });
    print(response);
    return response;
  }
}
