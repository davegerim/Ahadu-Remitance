import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ahadu_remittance/core/theme/colors.dart';

class TransactionDetailsScreen extends ConsumerWidget {
  const TransactionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppPalette.background,
      appBar: AppBar(
        backgroundColor: AppPalette.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppPalette.textPrimary),
          onPressed: () => context.go('/transactions'),
        ),
        title: Text(
          'Transaction Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppPalette.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppPalette.surface,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppPalette.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppPalette.successLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.check, color: AppPalette.success, size: 40),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Transfer Completed',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppPalette.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$150.00',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppPalette.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailsCard(theme),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(LucideIcons.download),
                label: const Text('Download Receipt'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.primaryLight,
                  foregroundColor: AppPalette.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppPalette.borderLight),
      ),
      child: Column(
        children: [
          _buildDetailRow(theme, 'Recipient', 'Dawit Gerim'),
          const Divider(height: 32, color: AppPalette.borderLight),
          _buildDetailRow(theme, 'Date & Time', 'Apr 25, 2026 02:15 PM'),
          const Divider(height: 32, color: AppPalette.borderLight),
          _buildDetailRow(theme, 'Reference No.', '#TRX-98234710'),
          const Divider(height: 32, color: AppPalette.borderLight),
          _buildDetailRow(theme, 'Fee', '\$2.50'),
          const Divider(height: 32, color: AppPalette.borderLight),
          _buildDetailRow(theme, 'Total Amount', '\$152.50', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(ThemeData theme, String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppPalette.textSecondary,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isTotal ? AppPalette.primary : AppPalette.textPrimary,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
