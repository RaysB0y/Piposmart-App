// // lib/providers/auth_provider.dart (versi mock sementara)
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // Mock data
// final tokenProvider = StateProvider<String?>((ref) => 'mock_token_123');
// final userProvider = StateProvider<Map<String, dynamic>?>(
//   (ref) => {'id': 1, 'name': 'Mario Wicaksono', 'email': 'owner@mewing.com'},
// );

// class AuthState {
//   final bool isLoading;
//   final String? error;
//   final bool isAuthenticated;

//   AuthState({this.isLoading = false, this.error, this.isAuthenticated = true});
// }

// class AuthNotifier extends StateNotifier<AuthState> {
//   AuthNotifier() : super(AuthState());

//   Future<bool> login(String email, String password, WidgetRef ref) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     ref.read(tokenProvider.notifier).state = 'mock_token';
//     ref.read(userProvider.notifier).state = {
//       'id': 1,
//       'name': 'User Mock',
//       'email': email,
//     };
//     return true;
//   }

//   Future<bool> register(String name, String email, String password) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     return true;
//   }

//   Future<void> logout(WidgetRef ref) async {
//     ref.read(tokenProvider.notifier).state = null;
//     ref.read(userProvider.notifier).state = null;
//   }

//   Future<void> checkAuthStatus(WidgetRef ref) async {
//     // Mock: sudah login
//     ref.read(tokenProvider.notifier).state = 'mock_token';
//   }
// }

// final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
//   return AuthNotifier();
// });
