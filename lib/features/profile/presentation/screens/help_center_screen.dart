import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ahadu_remittance/core/theme/colors.dart';

class HelpCenterScreen extends ConsumerWidget {
  const HelpCenterScreen({super.key});

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
          onPressed: () => context.go('/profile'),
        ),
        title: Text(
          'Help Center',
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
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for help...',
                prefixIcon: const Icon(LucideIcons.search),
                filled: true,
                fillColor: AppPalette.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppPalette.borderLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppPalette.borderLight),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildFAQSection(theme),
            const SizedBox(height: 32),
            _buildContactSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildFAQItem(theme, 'How long does a transfer take?', 'Most transfers are completed within minutes. Bank transfers may take up to 2 business days depending on the receiving bank.'),
        const SizedBox(height: 12),
        _buildFAQItem(theme, 'What are the transfer fees?', 'Fees vary based on the transfer amount and destination. You can review all fees before confirming a transfer.'),
        const SizedBox(height: 12),
        _buildFAQItem(theme, 'How do I track my transfer?', 'You can track your transfer status in the Transaction Details section from your history.'),
      ],
    );
  }

  Widget _buildFAQItem(ThemeData theme, String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppPalette.borderLight),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppPalette.borderLight),
      ),
      backgroundColor: AppPalette.surface,
      collapsedBackgroundColor: AppPalette.surface,
      children: [
        Text(
          answer,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppPalette.textSecondary, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildContactSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Still need help?',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildContactCard(theme, 'Live Chat', 'Typical reply in 5 mins', LucideIcons.messageSquare),
        const SizedBox(height: 12),
        _buildContactCard(theme, 'Email Support', 'support@ahadu.com', LucideIcons.mail),
        const SizedBox(height: 12),
        _buildContactCard(theme, 'Call Us', '+1 (800) 123-4567', LucideIcons.phone),
      ],
    );
  }

  Widget _buildContactCard(ThemeData theme, String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppPalette.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppPalette.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppPalette.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPalette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, color: AppPalette.textHint),
        ],
      ),
    );
  }
}
