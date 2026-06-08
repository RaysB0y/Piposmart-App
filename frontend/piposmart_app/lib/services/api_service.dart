// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _authToken;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('token');
    if (kDebugMode) {
      print('🔐 Loaded token: ${_authToken != null ? "Yes" : "No"}');
    }
  }

  // Tambahkan method getToken()
  Future<String?> getToken() async {
    await loadToken();
    return _authToken;
  }

  Future<void> saveToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    if (kDebugMode) print('🔐 Token saved');
  }

  Future<void> clearToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    if (kDebugMode) print('🔐 Token cleared');
  }

  Map<String, String> _getHeaders({bool requiresAuth = false}) {
    final headers = {'Content-Type': ApiConstants.contentType};
    if (requiresAuth && _authToken != null) {
      headers[ApiConstants.authorization] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    if (kDebugMode) {
      print('📡 Response: ${response.statusCode}');
      print('📡 Body: ${response.body}');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {'success': true};
      return json.decode(response.body);
    }

    String errorMessage;
    try {
      final errorBody = json.decode(response.body);
      errorMessage =
          errorBody['error'] ?? errorBody['message'] ?? 'Terjadi kesalahan';
    } catch (e) {
      switch (response.statusCode) {
        case 400:
          errorMessage = 'Data tidak valid';
          break;
        case 401:
          errorMessage = 'Email atau password salah';
          break;
        case 404:
          errorMessage = 'Data tidak ditemukan';
          break;
        case 500:
          errorMessage = 'Kesalahan server';
          break;
        default:
          errorMessage = 'Gagal terhubung ke server';
      }
    }
    throw ApiException(message: errorMessage, statusCode: response.statusCode);
  }

  // ==================== AUTH ENDPOINTS ====================
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}');
      final response = await http
          .post(
            url,
            headers: _getHeaders(),
            body: json.encode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 30));

      final data = await _handleResponse(response);
      if (data['token'] != null) await saveToken(data['token']);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}');
      final response = await http
          .post(
            url,
            headers: _getHeaders(),
            body: json.encode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 30));

      final data = await _handleResponse(response);
      if (data['token'] != null) await saveToken(data['token']);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== DASHBOARD ENDPOINTS ====================
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.dashboardStats}',
      );
      final response = await http
          .get(url, headers: _getHeaders(requiresAuth: true))
          .timeout(const Duration(seconds: 30));

      if (kDebugMode) {
        print('📡 Dashboard Stats Response: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('📡 Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? {};
      }
      return {};
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error in getDashboardStats: $e');
      }
      return {};
    }
  }

  // ==================== ITEMS ENDPOINTS ====================
  Future<List<dynamic>> getItems() async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.items}');
      final response = await http
          .get(url, headers: _getHeaders(requiresAuth: true))
          .timeout(const Duration(seconds: 30));

      final data = json.decode(response.body);
      if (data is List) return data;
      if (data is Map && data['data'] is List) return data['data'];
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // ==================== TRANSACTIONS ENDPOINTS ====================
  Future<List<dynamic>> getTransactions() async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.transactions}',
      );
      final response = await http
          .get(url, headers: _getHeaders(requiresAuth: true))
          .timeout(const Duration(seconds: 30));

      final data = json.decode(response.body);
      if (data is List) return data;
      if (data is Map && data['data'] is List) return data['data'];
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // ==================== CUSTOMER ENDPOINTS ====================
  Future<List<dynamic>> getCustomers() async {
    try {
      final token = await getToken();
      if (kDebugMode) {
        print('🔐 Token exists: ${token != null ? "Yes" : "No"}');
      }

      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.customers}');
      final response = await http
          .get(url, headers: _getHeaders(requiresAuth: true))
          .timeout(const Duration(seconds: 30));

      if (kDebugMode) {
        print('📡 Status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('📡 Raw body: ${response.body}');
      }
      if (kDebugMode) {
        print('📡 Body length: ${response.body.length}');
      }

      if (response.statusCode == 404) {
        throw Exception('Endpoint /api/customers tidak ditemukan (404)');
      }

      if (response.statusCode == 401) {
        throw Exception('Token tidak valid. Silakan login ulang.');
      }

      final data = json.decode(response.body);

      if (data is List) return data;
      if (data is Map && data['data'] is List) return data['data'];

      return [];
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error in getCustomers: $e');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createCustomer(
    Map<String, dynamic> customer,
  ) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.customers}');
      final response = await http
          .post(
            url,
            headers: _getHeaders(requiresAuth: true),
            body: json.encode(customer),
          )
          .timeout(const Duration(seconds: 30));

      if (kDebugMode) {
        print('📡 Create customer response: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('📡 Body: ${response.body}');
      }

      return json.decode(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateCustomer(
    int id,
    Map<String, dynamic> customer,
  ) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.customers}/$id',
      );
      final response = await http
          .put(
            url,
            headers: _getHeaders(requiresAuth: true),
            body: json.encode(customer),
          )
          .timeout(const Duration(seconds: 30));

      if (kDebugMode) {
        print('📡 Update customer response: ${response.statusCode}');
      }
      return json.decode(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.customers}/$id',
      );
      final response = await http
          .delete(url, headers: _getHeaders(requiresAuth: true))
          .timeout(const Duration(seconds: 30));

      if (kDebugMode) {
        print('📡 Delete customer response: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // ==================== ORDER ENDPOINTS ====================
  Future<List<dynamic>> getOrders() async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.orders}');
      final response = await http
          .get(url, headers: _getHeaders(requiresAuth: true))
          .timeout(const Duration(seconds: 30));

      final data = json.decode(response.body);
      if (data is List) return data;
      if (data is Map && data['data'] is List) return data['data'];
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> order) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.orders}');

      if (kDebugMode) {
        print('📡 POST URL: $url');
      }
      if (kDebugMode) {
        print('📡 Body: $order');
      }
      if (kDebugMode) {
        print('📡 Headers: ${_getHeaders(requiresAuth: true)}');
      }

      final response = await http
          .post(
            url,
            headers: _getHeaders(requiresAuth: true),
            body: json.encode(order),
          )
          .timeout(const Duration(seconds: 30));

      if (kDebugMode) {
        print('📡 RAW Response Status: ${response.statusCode}');
      }
      if (kDebugMode) {
        if (kDebugMode) {
          print('📡 RAW Response Body: ${response.body}');
        }
      }
      if (kDebugMode) {
        print('📡 RAW Response Headers: ${response.headers}');
      }

      if (response.statusCode == 404) {
        throw Exception(
          'Endpoint /api/orders tidak ditemukan (404). Periksa routes.go',
        );
      }

      if (response.statusCode == 401) {
        throw Exception('Token tidak valid. Silakan login ulang.');
      }

      if (response.statusCode == 500) {
        throw Exception('Server error (500). Cek log backend.');
      }

      final data = json.decode(response.body);
      return data;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error in createOrder: $e');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateOrderStatus(int id, String status) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.orders}/$id/status',
      );
      final response = await http
          .put(
            url,
            headers: _getHeaders(requiresAuth: true),
            body: json.encode({'status': status}),
          )
          .timeout(const Duration(seconds: 30));

      return json.decode(response.body);
    } catch (e) {
      rethrow;
    }
  }
}

// Helper function untuk min
int min(int a, int b) => a < b ? a : b;

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
