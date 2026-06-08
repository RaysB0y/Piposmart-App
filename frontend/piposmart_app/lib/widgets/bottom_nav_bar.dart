// lib/widgets/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class BottomNavBar extends ConsumerWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap, required Null Function() onScanTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    // Tentukan menu berdasarkan role
    List<Map<String, dynamic>> leftMenus = [];
    List<Map<String, dynamic>> rightMenus = [];

    if (user?.isOwner == true) {
      // Owner: 5 menu (kiri: Beranda, Transaksi, Layanan | kanan: Status, Akun)
      leftMenus = [
        {'icon': Icons.home_outlined, 'label': 'Beranda', 'index': 0},
        {'icon': Icons.receipt_long_outlined, 'label': 'Transaksi', 'index': 1},
      ];
      rightMenus = [
        {'icon': Icons.analytics_outlined, 'label': 'Status', 'index': 3},
        {'icon': Icons.person_outline, 'label': 'Akun', 'index': 4},
      ];
    } else if (user?.isKasir == true) {
      // Kasir: 4 menu (kiri: Transaksi, Layanan | kanan: Status, Akun)
      leftMenus = [
        {'icon': Icons.receipt_long_outlined, 'label': 'Transaksi', 'index': 1},
        {'icon': Icons.grid_view_outlined, 'label': 'Layanan', 'index': 2},
      ];
      rightMenus = [
        {'icon': Icons.analytics_outlined, 'label': 'Status', 'index': 3},
        {'icon': Icons.person_outline, 'label': 'Akun', 'index': 4},
      ];
    } else {
      // Karyawan: 2 menu (kiri: Status | kanan: Akun)
      leftMenus = [
        {'icon': Icons.analytics_outlined, 'label': 'Status', 'index': 3},
      ];
      rightMenus = [
        {'icon': Icons.person_outline, 'label': 'Akun', 'index': 4},
      ];
    }

    final bool showScanButton =
        (user?.isOwner == true || user?.isKasir == true);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            children: [
              // Menu KIRI
              Expanded(
                flex: leftMenus.length,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: leftMenus.map((menu) {
                    return _buildNavItem(
                      menu['icon'],
                      menu['label'],
                      menu['index'],
                    );
                  }).toList(),
                ),
              ),

              // Tombol SCAN (tengah) - Hanya untuk Owner & Kasir
              if (showScanButton)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: 56,
                  height: 56,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Scan akan segera hadir'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),

              // Menu KANAN
              Expanded(
                flex: rightMenus.length,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: rightMenus.map((menu) {
                    return _buildNavItem(
                      menu['icon'],
                      menu['label'],
                      menu['index'],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.bottomNavInactive,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? AppColors.primary
                    : AppColors.bottomNavInactive,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
