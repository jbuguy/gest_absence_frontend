import 'utilisateur.dart';

class LoginResponse {
  final bool success;
  final String message;
  final Utilisateur? user;

  LoginResponse({
    required this.success,
    required this.message,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json["success"] == 1,
      message: json["message"] ?? "",
      user: json["user"] != null ? Utilisateur.fromJson(json["user"]) : null,
    );
  }
}
