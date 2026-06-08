// lib/models/transactionModel.dart
class TransactionModel {
  final String id;
  final String status;
  final String outletName;
  final String statusPenerimaan;
  final int nominal; // Tetap int di UI
  final DateTime estimasiDiambil;
  final int jumlahLayanan;

  TransactionModel({
    required this.id,
    required this.status,
    required this.outletName,
    required this.statusPenerimaan,
    required this.nominal,
    required this.estimasiDiambil,
    required this.jumlahLayanan,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['transaction_code']?.toString() ?? json['id']?.toString() ?? '',
      status: json['payment_status'] ?? json['status'] ?? '',
      outletName: json['outlet_name'] ?? json['outletName'] ?? '',
      statusPenerimaan: json['order_status'] ?? json['statusPenerimaan'] ?? '',
      nominal: (json['total_price'] ?? json['nominal'] ?? 0).toInt(),
      estimasiDiambil: json['estimated_at'] != null
          ? DateTime.tryParse(json['estimated_at']) ?? DateTime.now()
          : DateTime.now(),
      jumlahLayanan: json['quantity'] ?? json['jumlah_layanan'] ?? 0,
    );
  }
}
