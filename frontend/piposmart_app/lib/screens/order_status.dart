// lib/screens/order_status.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../providers/auth_provider.dart';

class OrderStatus extends ConsumerStatefulWidget {
  const OrderStatus({super.key});

  @override
  ConsumerState<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends ConsumerState<OrderStatus> {
  List<dynamic> _orders = [];
  bool _isLoading = true;
  String? _error;
  String _activeFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final api = ApiService();
      final data = await api.getOrders();
      setState(() {
        _orders = data;
        _isLoading = false;
      });
      print('✅ Orders loaded: ${_orders.length}');
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('❌ Error fetching orders: $e');
    }
  }

  List<dynamic> get _filteredOrders {
    if (_activeFilter == 'Semua') return _orders;
    return _orders.where((o) => o['status'] == _activeFilter).toList();
  }

  int get _diterimaCount =>
      _orders.where((o) => o['status'] == 'diterima').length;
  int get _diprosesCount =>
      _orders.where((o) => o['status'] == 'diproses').length;
  int get _selesaiCount =>
      _orders.where((o) => o['status'] == 'selesai').length;
  int get _diambilCount =>
      _orders.where((o) => o['status'] == 'diambil').length;

  Future<void> _updateStatus(int id, String newStatus) async {
    try {
      final api = ApiService();
      await api.updateOrderStatus(id, newStatus);
      await _fetchOrders();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Status berhasil diupdate menjadi ${_getStatusName(newStatus)}',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Gagal: $e')));
    }
  }

  String _getStatusName(String status) {
    switch (status) {
      case 'diterima':
        return 'Diterima';
      case 'diproses':
        return 'Diproses';
      case 'selesai':
        return 'Selesai';
      case 'diambil':
        return 'Diambil';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'diterima':
        return Colors.blue;
      case 'diproses':
        return Colors.orange;
      case 'selesai':
        return Colors.green;
      case 'diambil':
        return Colors.purple;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(amount);
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  void _showUpdateStatusDialog(int id, String currentStatus) {
    final statuses = ['diterima', 'diproses', 'selesai', 'diambil'];
    final currentIndex = statuses.indexOf(currentStatus);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Update Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            ...statuses.asMap().entries.map((entry) {
              final idx = entry.key;
              final status = entry.value;
              final isEnabled = idx >= currentIndex;
              return ListTile(
                leading: Radio<String>(
                  value: status,
                  groupValue: currentStatus,
                  activeColor: AppColors.primary,
                  onChanged: isEnabled
                      ? (value) {
                          Navigator.pop(context);
                          _updateStatus(id, status);
                        }
                      : null,
                ),
                title: Text(_getStatusName(status)),
                subtitle: idx < currentIndex
                    ? Text(
                        'Tidak dapat mundur',
                        style: const TextStyle(fontSize: 11, color: Colors.red),
                      )
                    : null,
                enabled: isEnabled,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _getOutletName() {
    // Ambil dari authState user
    final user = ref.read(authStateProvider).user;
    return user?.outletName ?? 'Mewing Laundry';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final filteredOrders = _filteredOrders;

    // Hitung statistik dari data real orders
    final totalOrders = _orders.length;
    final countDiterima = _diterimaCount;
    final countDiproses = _diprosesCount;
    final countSelesai = _selesaiCount;
    final countDiambil = _diambilCount;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F7),
      appBar: AppBar(
        title: const Text('Status Orderan'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchOrders),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(_error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchOrders,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header greeting
                        Text(
                          'Hai, ${_getOutletName()}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ini pesanan yang harus kamu selesaikan',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Cards (dari data real)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSimpleStatusCard(
                            title: 'Diterima',
                            count: countDiterima,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSimpleStatusCard(
                            title: 'Diproses',
                            count: countDiproses,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSimpleStatusCard(
                            title: 'Selesai',
                            count: countSelesai,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSimpleStatusCard(
                            title: 'Diambil',
                            count: countDiambil,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Filter tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _buildFilterChip(
                          'Semua',
                          _activeFilter == 'Semua',
                          totalOrders,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'diterima',
                          _activeFilter == 'diterima',
                          countDiterima,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'diproses',
                          _activeFilter == 'diproses',
                          countDiproses,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'selesai',
                          _activeFilter == 'selesai',
                          countSelesai,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'diambil',
                          _activeFilter == 'diambil',
                          countDiambil,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // List orders
                  filteredOrders.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(child: Text('Tidak ada pesanan')),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = filteredOrders[index];
                            return _buildOrderCard(order, authState);
                          },
                        ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/transaction');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
        onScanTap: () {},
      ),
    );
  }

  Widget _buildSimpleStatusCard({
    required String title,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, int count) {
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label == 'Semua' ? 'Semua' : _getStatusName(label),
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white24
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(dynamic order, AuthState authState) {
    final customer = order['customer'];
    final item = order['item'];
    final status = order['status'];
    final statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['order_code'] ?? 'ORD-${order['id']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getStatusName(status),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  customer?['name'] ?? 'Customer #${order['customer_id']}',
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.local_laundry_service,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${item?['name'] ?? 'Item #${order['item_id']}'} x${order['quantity']}',
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(order['created_at']),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                'Rp ${_formatCurrency(order['total_price'])}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (authState.isOwner ||
              authState.isKasir ||
              (authState.isKaryawan &&
                  status != 'selesai' &&
                  status != 'diambil'))
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showUpdateStatusDialog(order['id'], status),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Update Status',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
