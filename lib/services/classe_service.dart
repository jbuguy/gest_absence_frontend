import 'package:gest_absence_frontend/config/api_config.dart';
import 'package:gest_absence_frontend/models/classe.dart';
import 'package:gest_absence_frontend/services/api_service.dart';

class ClasseService {
  final ApiService _api = ApiService();

  Future<List<Classe>> getClasses() async {
    final response = await _api.get(ApiConfig.classes);

    if (response["success"] == 1) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response["data"],
      );
      return data.map(Classe.fromJson).toList();
    }
    throw Exception(response["message"] ?? "Error fetching classes");
  }

  Future<void> addClasse(Classe classe) async {
    final response = await _api.post(ApiConfig.classes, classe.toJson());

    if (response["success"] == 1) {
      return;
    }
    throw Exception(response["message"] ?? "Error fetching classes");
  }

  Future<void> updateClasse(Classe classe) async {
    final response = await _api.put(ApiConfig.classes, classe.toJson());

    if (response["success"] == 1) {
      return;
    }
    throw Exception(response["message"] ?? "Error fetching classes");
  }

  Future<void> deleteClasse(int id) async {
    final response = await _api.delete(ApiConfig.classes, id: id);

    if (response["success"] == 1) {
      return;
    }
    throw Exception(response["message"] ?? "Error deleting classe");
  }
}
