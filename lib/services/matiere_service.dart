import 'package:gest_absence_frontend/config/api_config.dart';
import 'package:gest_absence_frontend/models/matiere.dart';
import 'package:gest_absence_frontend/services/api_service.dart';

class MatiereService {
  final ApiService _api = ApiService();

  Future<List<Matiere>> getMatieres() async {
    final response = await _api.get(ApiConfig.adminMatiere);

    if (response["success"] == 1) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response["data"],
      );
      return data.map(Matiere.fromJson).toList();
    }
    throw Exception(response["message"] ?? "Error fetching classes");
  }
}
