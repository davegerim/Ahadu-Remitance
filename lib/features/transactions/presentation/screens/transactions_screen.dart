import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ahadu_remittance/core/theme/colors.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppPalette.background,
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.filter),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 120), // Padding for nav bar
        itemCount: 10,
        separatorBuilder: (context, index) => const Divider(height: 32),
        itemBuilder: (context, index) {
          final isPositive = index % 3 == 0;
          return GestureDetector(
            onTap: () => context.go('/transaction-details'),
            child: _buildTransactionItem(
              theme,
              isPositive ? 'Salary Deposit' : 'Sent to Ethiopia',
              isPositive ? 'Received' : 'Completed',
              isPositive ? '+\$4,200.00' : '-\$150.00',
              'Apr ${25 - index}, 02:15 PM',
              isPositive ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight,
              isPositive: isPositive,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionItem(ThemeData theme, String name, String type, String amount, String date, IconData icon, {bool isPositive = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isPositive ? AppPalette.successLight : AppPalette.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: isPositive ? AppPalette.success : AppPalette.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                type,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isPositive ? AppPalette.success : AppPalette.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
