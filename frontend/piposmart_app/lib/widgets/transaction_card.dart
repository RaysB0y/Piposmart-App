// lib/widgets/transaction_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transactionModel.dart';
import '../utils/constants.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({super.key, required this.transaction});

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.id,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(transaction.status)?.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  transaction.status,
                  style: AppTextStyles.caption.copyWith(
                    color: _getStatusColor(transaction.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(transaction.outletName, style: AppTextStyles.body2),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  transaction.statusPenerimaan,
                  style: AppTextStyles.caption.copyWith(color: AppColors.info),
                ),
              ),
              Text(
                'Rp ${_formatCurrency(transaction.nominal)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Estimasi diambil', style: AppTextStyles.caption),
                  Text(
                    DateFormat(
                      'EEEE, dd-MM-yyyy HH:mm',
                      'id_ID',
                    ).format(transaction.estimasiDiambil),
                    style: AppTextStyles.body2,
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                },
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                child: const Text('Lihat Detail'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${transaction.jumlahLayanan} layanan',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Color? _getStatusColor(String status) {
    switch (status) {
      case 'Lunas':
        return AppColors.success;
      case 'Proses':
        return AppColors.warning;
      case 'Siap Diambil':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }
}
