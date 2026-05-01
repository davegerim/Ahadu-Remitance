import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ahadu_remittance/core/theme/colors.dart';

class RecipientSelectionScreen extends ConsumerWidget {
  const RecipientSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppPalette.background,
      appBar: AppBar(
        title: const Text('Select Recipient'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search name, email, or phone',
                  prefixIcon: const Icon(LucideIcons.search, color: AppPalette.textSecondary),
                  filled: true,
                  fillColor: AppPalette.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppPalette.borderLight, width: 1),
                  ),
                ),
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildSectionHeader(theme, 'Recent Recipients'),
                  _buildRecipientItem(context, theme, 'Abebe Kebede', '+251 911 234 567', 'Bank Deposit'),
                  _buildRecipientItem(context, theme, 'Dawit Tadesse', '+251 922 345 678', 'Mobile Money'),
                  
                  const SizedBox(height: 32),
                  _buildSectionHeader(theme, 'All Contacts'),
                  _buildRecipientItem(context, theme, 'Aster Bekele', '+251 933 456 789', 'Cash Pickup'),
                  _buildRecipientItem(context, theme, 'Chala Mengistu', '+251 944 567 890', 'Bank Deposit'),
                  _buildRecipientItem(context, theme, 'Emebet Alemu', '+251 955 678 901', 'Mobile Money'),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.plus),
                  label: const Text('Add New Recipient'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppPalette.textSecondary,
        ),
      ),
    );
  }

  Widget _buildRecipientItem(BuildContext context, ThemeData theme, String name, String phone, String method) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppPalette.borderLight, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppPalette.primaryLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              name[0],
              style: const TextStyle(
                color: AppPalette.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        title: Text(
          name,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '$phone • $method',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppPalette.background,
            shape: BoxShape.circle,
          ),
          child: const Icon(LucideIcons.chevronRight, size: 20, color: AppPalette.textPrimary),
        ),
        onTap: () {
          context.push('/review');
        },
      ),
    );
  }
}
