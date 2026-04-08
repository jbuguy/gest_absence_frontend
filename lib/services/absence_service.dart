import 'package:gest_absence_frontend/config/api_config.dart';
import 'package:gest_absence_frontend/models/absence.dart';
import 'package:gest_absence_frontend/models/request_absence.dart';
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

  Future<void> sendAppel(RequestAbsence request) async {
    final absences = request.absences.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    final map = {"seance_id": request.seanceId, "absences": absences};
    final response = await _api.post(ApiConfig.enseignantsAbsence, map);
    if (response["success"] == 1) {
      return;
    }
    throw Exception(response["message"] ?? "Error");
  }
}
