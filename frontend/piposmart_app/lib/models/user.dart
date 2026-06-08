// lib/models/user.dart
class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? outletName;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.outletName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'karyawan',
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

  bool get isOwner => role == 'owner';
  bool get isKasir => role == 'kasir';
  bool get isKaryawan => role == 'karyawan';
}
