import 'package:gest_absence_frontend/config/api_config.dart';
import 'package:gest_absence_frontend/models/absence.dart';
import 'package:gest_absence_frontend/services/api_service.dart';

class AbsenceService {
  final _api = ApiService();

  Future<List<Absence>> getAbsences(int userId) async {
    final response = await _api.get(ApiConfig.etudiantAbsence, id: userId);

    if (response["success"] == 1) {
      if (response["data"].length == 0) {
        return [];
      }
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response["data"],
      );
      return data.map(Absence.fromJson).toList();
    }

    throw Exception(response["message"] ?? "Error");
  }
}
