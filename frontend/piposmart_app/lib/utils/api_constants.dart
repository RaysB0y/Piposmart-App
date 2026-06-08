// lib/utils/api_constants.dart
class ApiConstants {
  // Untuk Chrome/Web (backend running di localhost)
  static const String baseUrl = 'http://localhost:8080';

  // Untuk device fisik
  // static const String baseUrl = 'http://192.168.1.4:8080';

  // Untuk emulator Android
  // static const String baseUrl = 'http://10.0.2.2:8080';

  static const String login = '/api/login';
  static const String register = '/api/register';
  static const String items = '/api/items';
  static const String transactions = '/api/transactions';
  static const String profile = '/api/profile';
  static const String dashboardStats = '/api/dashboard/stats';
  static const String customers = '/api/customers';
  static const String orders = '/api/orders';

  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
}
