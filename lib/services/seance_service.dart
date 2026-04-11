import 'package:gest_absence_frontend/config/api_config.dart';
import 'package:gest_absence_frontend/models/seance.dart';
import 'package:gest_absence_frontend/services/api_service.dart';

class SeanceService {
  final ApiService _api = ApiService();

  Future<List<Seance>> getSeancesAdmin() async {
    final response = await _api.get(ApiConfig.adminSeance);
    if (response["success"] == 1) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response["data"],
      );
      return data.map(Seance.fromJson).toList();
    }
    throw Exception(response["message"] ?? "Error fetching sessions");
  }

  Future<List<Seance>> getSeanceTeacher(int id) async {
    final response = await _api.get(ApiConfig.enseignantsSeance, id: id);
    if (response["success"] == 1) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response["data"],
      );
      return data.map(Seance.fromJson).toList();
    }
    throw Exception(response["message"] ?? "Error fetching sessions");
  }

  Future<void> createSeance(Seance seance) async {
    final response = await _api.post(ApiConfig.adminSeance, seance.toJson());
    if (response["success"] == 1) {
      return;
    }
    throw Exception(response["message"] ?? "error creating seance");
  }

  Future<void> updateSeance(Seance seance) async {
    final response = await _api.put(ApiConfig.adminSeance, seance.toJson());
    if (response["success"] == 1) {
      return;
    }
    throw Exception(response["message"] ?? "error creating seance");
  }
}
