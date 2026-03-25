import 'package:gest_absence_frontend/config/api_config.dart';
import 'package:gest_absence_frontend/models/seance.dart';
import 'package:gest_absence_frontend/services/api_service.dart';

class SeanceService {
  final ApiService _api = ApiService();

  Future<List<Seance>> getSeances() async {
    final response = await _api.get(ApiConfig.seances);
    if (response["success"] == 1) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response["data"],
      );
      return data.map(Seance.fromJson).toList();
    }
    throw Exception(response["message"] ?? "Error fetching sessions");
  }
}
