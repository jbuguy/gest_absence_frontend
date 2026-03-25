import 'package:gest_absence_frontend/config/api_config.dart';
import 'package:gest_absence_frontend/models/profile.dart';
import 'package:gest_absence_frontend/services/api_service.dart';

class AbsenceService {
  final _api = ApiService();

  Future<Profile?> getProfile(int userId) async {
    final response = await _api.get(ApiConfig.etudiantProfile, id: userId);

    if (response["success"] == 1) {
      return Profile.fromJson(response["data"]);
    }

    throw Exception(response["message"] ?? "Error");
  }
}
