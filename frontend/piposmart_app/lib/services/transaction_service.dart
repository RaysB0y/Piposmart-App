// // lib/services/transaction_service.dart
// import 'package:http/http.dart';

// import 'api_service.dart';
// import '../utils/api_constants.dart';

// class TransactionService {
//   final ApiService _api = ApiService();

//   Future<List<dynamic>> getTransactions() async {
//     try {
//       final response = await _api.get(ApiConstants.transactions);
//       return response['data'] ?? [];
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<Map<String, dynamic>> getTransactionDetail(String id) async {
//     try {
//       final response = await _api.get('${ApiConstants.transactions}/$id');
//       return response['data'] ?? {};
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
