// // lib/services/auth_service.dart

// import 'package:http/http.dart';

// import 'api_service.dart';
// import '../utils/api_constants.dart';
// import '../models/auth_response.dart';

// class AuthService {
//   final ApiService _api = ApiService();

//   Future<AuthResponse> login(String email, String password) async {
//     try {
//       final response = await _api.post(
//         ApiConstants.login,
//         data: {'email': email, 'password': password},
//         requiresAuth: false,
//       );

//       if (response['token'] != null) {
//         await _api.setAuthToken(response['token']);
//       }

//       return AuthResponse.fromJson(response);
//     } catch (e) {
//       if (e is ApiException) {
//         return AuthResponse(success: false, message: e.message);
//       }
//       return AuthResponse(success: false, message: 'Gagal terhubung ke server');
//     }
//   }

//   Future<AuthResponse> register(
//     String name,
//     String email,
//     String password,
//   ) async {
//     try {
//       final response = await _api.post(
//         ApiConstants.register,
//         data: {'name': name, 'email': email, 'password': password},
//         requiresAuth: false,
//       );

//       if (response['token'] != null) {
//         await _api.setAuthToken(response['token']);
//       }

//       return AuthResponse.fromJson(response);
//     } catch (e) {
//       if (e is ApiException) {
//         return AuthResponse(success: false, message: e.message);
//       }
//       return AuthResponse(success: false, message: 'Gagal terhubung ke server');
//     }
//   }

//   Future<void> logout() async {
//     await _api.clearAuthToken();
//   }

//   Future<bool> isLoggedIn() async {
//     await _api.loadToken();
//     return _api.authToken != null;
//   }
// }
