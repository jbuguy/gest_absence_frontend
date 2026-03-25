import 'package:gest_absence_frontend/config/api_config.dart';
import 'package:gest_absence_frontend/services/api_service.dart';

class AdminService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getStats() async {
    final response = await _api.get(ApiConfig.adminStats);
    return response;
  }
}