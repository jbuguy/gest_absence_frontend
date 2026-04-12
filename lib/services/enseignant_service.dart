import 'package:gest_absence_frontend/config/api_config.dart';
import 'package:gest_absence_frontend/models/enseignant.dart';
import 'package:gest_absence_frontend/services/api_service.dart';

class EnseignantService {
  final ApiService _api = ApiService();

  Future<List<Enseignant>> getEnseignants() async {
    final response = await _api.get(ApiConfig.adminEnseignant);
    if (response["success"] == 1) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response["data"],
      );
      return data.map(Enseignant.fromJson).toList();
    }
    throw Exception(response["message"] ?? "Error fetching teachers");
  }
  Future<void> createEnseignant(Enseignant ens, String password) async {
    final body = ens.toJson();
    body["password"] = password;
    final response = await _api.post(ApiConfig.adminEnseignant, body);
    if (response["success"] != 1) throw Exception(response["message"]);
  }

  Future<void> updateEnseignant(Enseignant ens) async {
    final response = await _api.put(ApiConfig.adminEnseignant, ens.toJson());
    if (response["success"] != 1) throw Exception(response["message"]);
  }
}
