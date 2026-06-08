// lib/providers/mock_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock data untuk auth
final mockTokenProvider = StateProvider<String?>((ref) => 'mock_token_12345');
final mockUserProvider = StateProvider<Map<String, dynamic>?>(
  (ref) => {
    'id': 1,
    'name': 'Mario Wicaksono',
    'email': 'owner@mewing.com',
    'role': 'Owner',
  },
);

// Mock auth state
class MockAuthNotifier extends StateNotifier<dynamic> {
  bool isLoading = false;
  String? error;
  bool isAuthenticated = true; // Set true agar langsung ke dashboard

  MockAuthNotifier() : super(null);

  Future<bool> login(String email, String password, WidgetRef ref) async {
    // Simulasi login berhasil
    await Future.delayed(const Duration(seconds: 1));
    ref.read(mockTokenProvider.notifier).state = 'mock_token_12345';
    ref.read(mockUserProvider.notifier).state = {
      'id': 1,
      'name': 'Mario Wicaksono',
      'email': email,
      'role': 'Owner',
    };
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<void> logout(WidgetRef ref) async {
    ref.read(mockTokenProvider.notifier).state = null;
    ref.read(mockUserProvider.notifier).state = null;
  }

  Future<void> checkAuthStatus(WidgetRef ref) async {
    // Biarkan saja, token sudah ada
  }
}

final mockAuthStateProvider = StateNotifierProvider<MockAuthNotifier, dynamic>((
  ref,
) {
  return MockAuthNotifier();
});
