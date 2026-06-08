// lib/utils/role_constants.dart
class RoleConstants {
  static const String owner = 'owner';
  static const String kasir = 'kasir';
  static const String karyawan = 'karyawan';

  static const List<String> allRoles = [owner, kasir, karyawan];

  static String getRoleName(String role) {
    switch (role) {
      case owner:
        return 'Pemilik';
      case kasir:
        return 'Kasir';
      case karyawan:
        return 'Karyawan';
      default:
        return 'User';
    }
  }
}
