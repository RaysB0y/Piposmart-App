// lib/models/auth_response.dart
class AuthResponse {
  final bool success;
  final String? message;
  final String? token;
  final UserModel? user;

  AuthResponse({required this.success, this.message, this.token, this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'],
      token: json['token'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? role;
  final String? outletName;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.outletName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'],
      outletName: json['outlet_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'outlet_name': outletName,
    };
  }
}
