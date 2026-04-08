import 'package:gest_absence_frontend/config/api_config.dart';
import 'package:gest_absence_frontend/models/utilisateur.dart';
import 'package:gest_absence_frontend/services/api_service.dart';

class EtudiantService {
  final ApiService _api = ApiService();

  Future<List<Utilisateur>> getEtudiants() async {
    final response = await _api.get(ApiConfig.etudiants);
    if (response["success"] == 1) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response["data"],
      );
      return data.map(Utilisateur.fromJson).toList();
    }
    throw Exception(response["message"] ?? "Error fetching students");
  }

  Future<List<Utilisateur>> getEtudiantsByClasse(int id) async {
    final response = await _api.get(ApiConfig.enseignantsClasse, id: id);
    if (response["success"] == 1) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response["data"],
      );
      return data.map(Utilisateur.fromJson).toList();
    }
    throw Exception(response["message"] ?? "Error fetching students");
  }
}
