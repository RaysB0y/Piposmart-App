// lib/data/mock_data.dart
import '../models/transactionModel.dart';

class MockData {
  // Data untuk Dashboard (Halaman 2)
  static const user = {
    'name': 'Mario Wicaksono',
    'role': 'Owner',
    'outlet': 'Mewing Laundry',
    'greeting': 'Semangat tingkatkan omset',
  };

  static const keuangan = {
    'pendapatan_bersih': 0,
    'pengeluaran': 0,
    'pembayaran': 0,
    'pengeluaran_kotor': 0,
  };

  static const outlet = {'penjualan': 0, 'pendapatan_kotor': 0};

  // Data untuk Status Orderan (Halaman 1)
  static const orderStats = {'selesai': 0, 'terlambat': 20, 'harus_selesai': 0};

  // Data untuk Transaksi (Halaman 3) - Ubah Transaction jadi TransactionModel
  static List<TransactionModel> transactions = [
    TransactionModel(
      id: 'TR/9127/23',
      status: 'Lunas',
      outletName: '10461-AMM LAUNDRY PALU-Bunda Ama',
      statusPenerimaan: 'Diterima',
      nominal: 1000000, // ← int, tanpa .0
      estimasiDiambil: DateTime(2025, 7, 10, 10, 25),
      jumlahLayanan: 1,
    ),
    TransactionModel(
      id: 'TR/9127/22',
      status: 'Lunas',
      outletName: '10461-AMM LAUNDRY PALU-Bunda Ama',
      statusPenerimaan: 'Diterima',
      nominal: 900000, // ← int
      estimasiDiambil: DateTime(2025, 7, 5, 9, 41),
      jumlahLayanan: 4,
    ),
    TransactionModel(
      id: 'TR/9127/21',
      status: 'Proses',
      outletName: 'Laundry Cepat Jaya',
      statusPenerimaan: 'Diproses',
      nominal: 500000, // ← int
      estimasiDiambil: DateTime(2025, 7, 8, 14, 30),
      jumlahLayanan: 2,
    ),
    TransactionModel(
      id: 'TR/9127/20',
      status: 'Siap Diambil',
      outletName: 'Berkah Laundry',
      statusPenerimaan: 'Siap diambil',
      nominal: 750000, // ← int
      estimasiDiambil: DateTime(2025, 7, 6, 11, 0),
      jumlahLayanan: 3,
    ),
  ];

  // Data untuk Profile (Halaman 4)
  static const profileMenus = [
    'Profil Saya',
    'Printer & Nota',
    'Ganti Password',
    'Berikan Ulasan PlayStore',
    'Syarat dan Ketentuan',
    'Kebijakan Privasi',
    'Tentang Kami',
    'Bagikan Aplikasi',
  ];

  static const version = 'Piposmart 6.0.2';
  static const tagline = '#pakePIPOSMARTaja';
}
