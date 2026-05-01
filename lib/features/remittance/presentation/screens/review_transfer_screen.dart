import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ahadu_remittance/core/theme/colors.dart';

class ReviewTransferScreen extends ConsumerWidget {
  const ReviewTransferScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppPalette.background,
      appBar: AppBar(
        title: const Text('Review Transfer'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Summary
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppPalette.primaryLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppPalette.primary.withValues(alpha: 0.2), width: 2),
                      ),
                      child: const Center(
                        child: Text(
                          'AK',
                          style: TextStyle(
                            color: AppPalette.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'You are sending',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$100.00',
                      style: theme.textTheme.displayLarge,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppPalette.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppPalette.borderLight, width: 1),
                      ),
                      child: Text(
                        '1 USD = 125.50 ETB',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppPalette.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Recipient Details
              _buildSectionHeader(theme, 'Recipient Details'),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppPalette.surface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: AppPalette.borderLight, width: 1),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(theme, 'Name', 'Abebe Kebede'),
                    const Divider(height: 32),
                    _buildDetailRow(theme, 'Delivery Method', 'Bank Deposit'),
                    const Divider(height: 32),
                    _buildDetailRow(theme, 'Bank Name', 'Ahadu Bank'),
                    const Divider(height: 32),
                    _buildDetailRow(theme, 'Account Number', '1000123456789'),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),

              // Transfer Details
              _buildSectionHeader(theme, 'Transfer Details'),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppPalette.surfaceDark,
                  borderRadius: BorderRadius.circular(32),
                  image: DecorationImage(
                    image: const AssetImage('assets/images/ahadu_tilet.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      AppPalette.surfaceDark.withValues(alpha: 0.85),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(theme, 'Amount Sent', '\$100.00', isDark: true),
                    const Divider(height: 32, color: Colors.white24),
                    _buildDetailRow(theme, 'Transfer Fee', '\$2.99', isDark: true),
                    const Divider(height: 32, color: Colors.white24),
                    _buildDetailRow(theme, 'Total to Pay', '\$102.99', isTotal: true, isDark: true),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recipient Gets',
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                          ),
                          Text(
                            '12,550.00 ETB',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppPalette.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/success');
                  },
                  child: const Text('Confirm & Send'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppPalette.textSecondary,
        ),
      ),
    );
  }

  Widget _buildDetailRow(ThemeData theme, String label, String value, {bool isTotal = false, bool isDark = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? Colors.white70 : AppPalette.textSecondary,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isDark ? Colors.white : AppPalette.textPrimary,
          ),
        ),
      ],
    );
  }
}
