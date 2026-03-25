import 'package:gest_absence_frontend/config/api_config.dart';
import 'package:gest_absence_frontend/models/utilisateur.dart';
import 'package:gest_absence_frontend/services/api_service.dart';

class EnseignantService {
  final ApiService _api = ApiService();

  Future<List<Utilisateur>> getEnseignants() async {
    final response = await _api.get(ApiConfig.enseignants);
    if (response["success"] == 1) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response["data"],
      );
      return data.map(Utilisateur.fromJson).toList();
    }
    throw Exception(response["message"] ?? "Error fetching teachers");
  }
}
