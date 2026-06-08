// lib/models/dashboard_stats.dart
class DashboardStats {
  final int pendapatanBersih;
  final int pendapatanKotor;
  final int pengeluaran;
  final int penjualan;

  DashboardStats({
    required this.pendapatanBersih,
    required this.pendapatanKotor,
    required this.pengeluaran,
    required this.penjualan,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      pendapatanBersih: json['pendapatan_bersih'] ?? 0,
      pendapatanKotor: json['pendapatan_kotor'] ?? 0,
      pengeluaran: json['pengeluaran'] ?? 0,
      penjualan: json['penjualan'] ?? 0,
    );
  }
}