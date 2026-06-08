// lib/providers/dashboard_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

final dashboardStatsProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final api = ApiService();
  try {
    return await api.getDashboardStats();
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching dashboard stats: $e');
    }
    return {};
  }
});
