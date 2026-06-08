// lib/widgets/status_card.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StatusCard extends StatelessWidget {
  final String title;
  final int value;
  final Color color;
  final VoidCallback onTap;

  const StatusCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: AppTextStyles.body2,
            ),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onTap,
              child: const Text('Lihat Detail'),
            ),
          ],
        ),
      ),
    );
  }
}