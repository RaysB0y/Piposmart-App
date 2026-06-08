// lib/screens/dashboard.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:piposmart_app/services/api_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../utils/constants.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  int _selectedTab = 0;
  final NumberFormat _currencyFormat = NumberFormat('#,###', 'id_ID');

  // Data dari API
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _items = [];

  bool _isLoadingCustomers = false;
  bool _isLoadingItems = false;

  // Controller untuk tambah pelanggan
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final TextEditingController _customerAddressController =
      TextEditingController();

  // Controller untuk edit pelanggan (inisialisasi di initState)
  late final TextEditingController _editCustomerNameController;
  late final TextEditingController _editCustomerPhoneController;
  late final TextEditingController _editCustomerAddressController;
  int? _editingCustomerId;

  // Controller untuk pesanan
  final TextEditingController _orderQuantityController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller edit
    _editCustomerNameController = TextEditingController();
    _editCustomerPhoneController = TextEditingController();
    _editCustomerAddressController = TextEditingController();

    _fetchCustomers();
    _fetchItems();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerAddressController.dispose();
    _editCustomerNameController.dispose();
    _editCustomerPhoneController.dispose();
    _editCustomerAddressController.dispose();
    _orderQuantityController.dispose();
    super.dispose();
  }

  String _formatCurrency(int value) {
    if (value == 0) return '0';
    return _currencyFormat.format(value);
  }

  // ==================== API CALLS ====================
  Future<void> _fetchCustomers() async {
    setState(() => _isLoadingCustomers = true);
    try {
      final api = ApiService();
      final data = await api.getCustomers();
      setState(() {
        _customers = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching customers: $e');
      }
    } finally {
      setState(() => _isLoadingCustomers = false);
    }
  }

  Future<void> _fetchItems() async {
    setState(() => _isLoadingItems = true);
    try {
      final api = ApiService();
      final data = await api.getItems();
      setState(() {
        _items = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching items: $e');
      }
    } finally {
      setState(() => _isLoadingItems = false);
    }
  }

  // ==================== CUSTOMER CRUD ====================
  Future<void> _addCustomer() async {
    if (_customerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama pelanggan harus diisi')),
      );
      return;
    }

    try {
      final api = ApiService();
      await api.createCustomer({
        'name': _customerNameController.text,
        'phone': _customerPhoneController.text,
        'address': _customerAddressController.text,
      });
      _customerNameController.clear();
      _customerPhoneController.clear();
      _customerAddressController.clear();
      await _fetchCustomers();
      if (mounted) Navigator.pop(context);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Pelanggan berhasil ditambahkan')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Gagal: $e')));
    }
  }

  void _openEditCustomerDialog(Map<String, dynamic> customer) {
    // Set nilai ke controller
    _editCustomerNameController.text = customer['name'] ?? '';
    _editCustomerPhoneController.text = customer['phone'] ?? '';
    _editCustomerAddressController.text = customer['address'] ?? '';
    _editingCustomerId = customer['id'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Pelanggan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _editCustomerNameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _editCustomerPhoneController,
              decoration: const InputDecoration(
                labelText: 'No. Telepon',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _editCustomerAddressController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _clearEditCustomerControllers();
              Navigator.pop(context);
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _updateCustomer();
              // ignore: use_build_context_synchronously
              if (mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _clearEditCustomerControllers() {
    _editCustomerNameController.clear();
    _editCustomerPhoneController.clear();
    _editCustomerAddressController.clear();
    _editingCustomerId = null;
  }

  Future<void> _updateCustomer() async {
    if (_editCustomerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama pelanggan harus diisi')),
      );
      return;
    }

    if (_editingCustomerId == null) return;

    try {
      final api = ApiService();
      await api.updateCustomer(_editingCustomerId!, {
        'name': _editCustomerNameController.text,
        'phone': _editCustomerPhoneController.text,
        'address': _editCustomerAddressController.text,
      });
      _clearEditCustomerControllers();
      await _fetchCustomers();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Pelanggan berhasil diupdate')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Gagal: $e')));
    }
  }

  Future<void> _deleteCustomer(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pelanggan'),
        content: const Text('Yakin ingin menghapus pelanggan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        final api = ApiService();
        await api.deleteCustomer(id);
        await _fetchCustomers();
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Pelanggan dihapus')));
      } catch (e) {
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Gagal: $e')));
      }
    }
  }

  // ==================== ORDER CRUD ====================
  Future<void> _addOrder(int customerId, int itemId, int quantity) async {
    try {
      final api = ApiService();
      final result = await api.createOrder({
        'customer_id': customerId,
        'item_id': itemId,
        'quantity': quantity,
      });

      if (kDebugMode) {
        print('✅ Order created: $result');
      }

      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('✅ Pesanan berhasil dibuat!')));

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creating order: $e');
      }
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Gagal: $e')));
    }
  }

  // ==================== MODALS ====================
  void _showCustomerModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Manajemen Pelanggan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tambah Pelanggan Baru',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _customerNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _customerPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'No. Telepon',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _customerAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addCustomer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Tambah Pelanggan'),
                  ),
                ),
                const Divider(height: 32),
                const Text(
                  'Daftar Pelanggan',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                _isLoadingCustomers
                    ? const Center(child: CircularProgressIndicator())
                    : _customers.isEmpty
                    ? const Center(child: Text('Belum ada pelanggan'))
                    : ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _customers.length,
                          itemBuilder: (context, index) {
                            final customer = _customers[index];
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(customer['name']),
                              subtitle: Text(customer['phone'] ?? '-'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context); // Tutup modal
                                      _openEditCustomerDialog(customer);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        _deleteCustomer(customer['id']),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showOrderModal() {
    int? selectedCustomerId;
    int? selectedItemId;
    int quantity = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'Buat Pesanan Baru',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pilih Pelanggan',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  hint: const Text('Pilih Pelanggan'),
                  items: _customers.map((c) {
                    return DropdownMenuItem<int>(
                      value: c['id'],
                      child: Text(c['name']),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setStateModal(() => selectedCustomerId = value),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pilih Layanan',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.local_laundry_service),
                  ),
                  hint: const Text('Pilih Layanan'),
                  items: _items.map((i) {
                    return DropdownMenuItem<int>(
                      value: i['id'],
                      child: Text(
                        '${i['name']} - Rp ${_formatCurrency(i['price'])}',
                      ),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setStateModal(() => selectedItemId = value),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Jumlah (Kg / pcs)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _orderQuantityController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => quantity = int.tryParse(value) ?? 1,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        (selectedCustomerId != null && selectedItemId != null)
                        ? () => _addOrder(
                            selectedCustomerId!,
                            selectedItemId!,
                            quantity,
                          )
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Buat Pesanan'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showItemsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text(
                'Daftar Layanan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            _isLoadingItems
                ? const Center(child: CircularProgressIndicator())
                : _items.isEmpty
                ? const Center(child: Text('Belum ada layanan'))
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return ListTile(
                          leading: const Icon(
                            Icons.local_laundry_service,
                            color: AppColors.primary,
                          ),
                          title: Text(item['name']),
                          subtitle: Text(
                            'Rp ${_formatCurrency(item['price'])}',
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final dashboardStatsAsync = ref.watch(dashboardStatsProvider);

    if (!authState.isOwner) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (authState.isKasir) {
          Navigator.pushReplacementNamed(context, '/transaction');
        } else {
          Navigator.pushReplacementNamed(context, '/order-status');
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authState.user;
    final outletName = user?.outletName ?? 'Mewing Laundry';
    final userName = user?.name ?? 'Mario Wicaksono';
    final userRole = user?.role ?? 'OWNER';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildPremiumHeader(userName, userRole, outletName),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildFinanceCardWithStats(dashboardStatsAsync),
                  const SizedBox(height: 24),
                  _buildQuickAccessSection(),
                  const SizedBox(height: 24),
                  _buildPromoCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/transaction');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/order-status');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
        onScanTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur Scan akan segera hadir')),
          );
        },
      ),
    );
  }

  // ==================== HEADER ====================
  Widget _buildPremiumHeader(
    String userName,
    String userRole,
    String outletName,
  ) {
    final initial = userName.isNotEmpty ? userName[0] : 'U';
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + (isSmallScreen ? 16 : 20),
        left: 20,
        right: 20,
        bottom: isSmallScreen ? 24 : 32,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: isSmallScreen ? 20 : 24,
                    backgroundColor: Colors.white24,
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userRole.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isSmallScreen ? 9 : 10,
                        ),
                      ),
                      Text(
                        userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  _headerIcon(Icons.search_outlined, isSmallScreen),
                  const SizedBox(width: 12),
                  _headerIcon(
                    Icons.notifications_none,
                    isSmallScreen,
                    hasBadge: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Hai, ${outletName.split(' ')[0]}\nLaundry',
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 24 : 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Semangat tingkatkan omset\nhari ini!',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _headerAction(Icons.history_outlined, 'History', isSmallScreen),
              const SizedBox(width: 16),
              _headerAction(
                Icons.account_balance_wallet_outlined,
                'Top Up',
                isSmallScreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(
    IconData icon,
    bool isSmallScreen, {
    bool hasBadge = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
      decoration: const BoxDecoration(
        color: Colors.white12,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          Icon(icon, color: Colors.white, size: isSmallScreen ? 18 : 22),
          if (hasBadge)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _headerAction(IconData icon, String label, bool isSmallScreen) {
    return GestureDetector(
      onTap: () => _showComingSoon(label),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 10 : 14,
          vertical: isSmallScreen ? 8 : 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 14),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: isSmallScreen ? 18 : 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 9 : 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== FINANCE CARD ====================
  Widget _buildFinanceCard(Map<String, dynamic> stats) {
    // Ambil data dari _dashboardStats;
    final totalIncome = stats['total_income'] ?? 0;
    final totalOrders = stats['total_orders'] ?? 0;
    final totalCustomers = stats['total_customers'] ?? 0;
    final pendingOrders = stats['pending_orders'] ?? 0;
    final totalItems = stats['total_items'] ?? 0;

    // Debug
    if (kDebugMode) {
      print('📊 totalIncome: $totalIncome');
    }
    if (kDebugMode) {
      print('📊 totalOrders: $totalOrders');
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 20),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildTabItem('Keuangan', 0, isSmallScreen),
              _buildTabItem('Ringkasan', 1, isSmallScreen),
              _buildTabItem('Outlet', 2, isSmallScreen),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _selectedTab == 0
                ? _buildKeuanganTab(
                    totalIncome,
                    totalOrders,
                    totalCustomers,
                    pendingOrders,
                  )
                : _selectedTab == 1
                ? _buildRingkasanTab(totalOrders, totalCustomers, totalItems)
                : _buildOutletTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceCardWithStats(
    AsyncValue<Map<String, dynamic>> statsAsync,
  ) {
    return statsAsync.when(
      data: (stats) {
        return _buildFinanceCard(stats);
      },
      loading: () {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stack) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(height: 8),
              Text('Gagal memuat data: $error'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabItem(String label, int index, bool isSmallScreen) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primarySurface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isActive ? Border.all(color: AppColors.border) : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: isSmallScreen ? 11 : 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeuanganTab(
    int totalIncome,
    int totalOrders,
    int totalCustomers,
    int pendingOrders,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 380 ? 1 : 2;
    return GridView.count(
      key: const ValueKey('keuangan'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.5,
      children: [
        _financeCard(
          'PENDAPATAN',
          'Rp ${_formatCurrency(totalIncome)}',
          const Color(0xFF00A36C),
          Icons.payments_outlined,
        ),
        _financeCard(
          'TOTAL PESANAN',
          totalOrders.toString(),
          const Color(0xFFFFA500),
          Icons.receipt_outlined,
          isCurrency: false,
        ),
        _financeCard(
          'PELANGGAN',
          totalCustomers.toString(),
          const Color(0xFF2563EB),
          Icons.people_outline,
          isCurrency: false,
        ),
        _financeCard(
          'PENDING',
          pendingOrders.toString(),
          const Color(0xFFE11D48),
          Icons.pending_outlined,
          isCurrency: false,
        ),
      ],
    );
  }

  Widget _buildRingkasanTab(
    int totalOrders,
    int totalCustomers,
    int totalItems,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 380 ? 1 : 2;
    return GridView.count(
      key: const ValueKey('ringkasan'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.5,
      children: [
        _financeCard(
          'TOTAL PESANAN',
          totalOrders.toString(),
          const Color(0xFF00A36C),
          Icons.receipt_outlined,
          isCurrency: false,
        ),
        _financeCard(
          'TOTAL PELANGGAN',
          totalCustomers.toString(),
          const Color(0xFFFFA500),
          Icons.people_outline,
          isCurrency: false,
        ),
        _financeCard(
          'TOTAL LAYANAN',
          totalItems.toString(),
          const Color(0xFF2563EB),
          Icons.local_laundry_service,
          isCurrency: false,
        ),
      ],
    );
  }

  Widget _buildOutletTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 380 ? 1 : 2;
    return GridView.count(
      key: const ValueKey('outlet'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.5,
      children: [
        _financeCard(
          'PENJUALAN',
          '0',
          const Color(0xFF00A36C),
          Icons.shopping_bag_outlined,
          isCurrency: false,
        ),
        _financeCard(
          'PENDAPATAN KOTOR',
          'Rp 0',
          const Color(0xFFFFA500),
          Icons.account_balance_wallet_outlined,
        ),
        _financeCard(
          'TOTAL OUTLET',
          '1',
          const Color(0xFF2563EB),
          Icons.storefront_outlined,
          isCurrency: false,
        ),
        _financeCard(
          'LAPORAN USAHA',
          'Lihat',
          const Color(0xFFE11D48),
          Icons.bar_chart_outlined,
          isLink: true,
          isCurrency: false,
        ),
      ],
    );
  }

  Widget _financeCard(
    String title,
    String value,
    Color color,
    IconData icon, {
    bool isCurrency = true,
    bool isLink = false,
  }) {
    return GestureDetector(
      onTap: () => _showComingSoon(title),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  isLink
                      ? Row(
                          children: [
                            Text(
                              value,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 10,
                              color: color,
                            ),
                          ],
                        )
                      : Text(
                          value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== QUICK ACCESS ====================
  Widget _buildQuickAccessSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 380 ? 3 : 4;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AKSES CEPAT',
            style: TextStyle(
              letterSpacing: 1.2,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 8,
            childAspectRatio: 0.9,
            children: [
              _quickAccessItem(Icons.local_laundry_service_outlined, 'Pesanan'),
              _quickAccessItem(
                Icons.settings_input_component_outlined,
                'Layanan',
              ),
              _quickAccessItem(Icons.people_outline, 'Pelanggan'),
              _quickAccessItem(Icons.badge_outlined, 'Karyawan'),
              _quickAccessItem(Icons.add_business_outlined, 'Tambah Outlet'),
              _quickAccessItem(
                Icons.account_balance_wallet_outlined,
                'Pengeluaran',
              ),
              _quickAccessItem(Icons.analytics_outlined, 'Laporan'),
              _quickAccessItem(Icons.grid_view_outlined, 'Semua'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAccessItem(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Pelanggan') {
          _showCustomerModal();
        } else if (label == 'Pesanan')
          // ignore: curly_braces_in_flow_control_structures
          _showOrderModal();
        else if (label == 'Layanan')
          // ignore: curly_braces_in_flow_control_structures
          _showItemsModal();
        else
          // ignore: curly_braces_in_flow_control_structures
          _showComingSoon(label);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.5),
              ),
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ==================== PROMO CARD ====================
  Widget _buildPromoCard() {
    return GestureDetector(
      onTap: () => _showPromoDialog(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.card_giftcard,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Lihat Promo Menarik',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Penawaran khusus bulan ini',
                    style: TextStyle(color: Colors.black54, fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }

  // ==================== HELPER ====================
  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur $feature akan segera hadir'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.textPrimary,
      ),
    );
  }

  void _showPromoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 Promo Spesial!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.local_offer, size: 48, color: AppColors.primary),
            SizedBox(height: 12),
            Text(
              'Diskon 20% untuk laundry pertama kamu!',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Gunakan kode: LAUNDRY20',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
