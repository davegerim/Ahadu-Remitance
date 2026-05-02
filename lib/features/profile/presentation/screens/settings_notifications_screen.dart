import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ahadu_remittance/core/theme/colors.dart';

class SettingsNotificationsScreen extends ConsumerWidget {
  const SettingsNotificationsScreen({super.key});

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
          'Notification Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppPalette.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSettingsTile(theme, 'Push Notifications', 'Receive push alerts on this device', true),
          const SizedBox(height: 16),
          _buildSettingsTile(theme, 'Email Notifications', 'Receive emails for transactions', false),
          const SizedBox(height: 16),
          _buildSettingsTile(theme, 'SMS Notifications', 'Receive text alerts', true),
          const SizedBox(height: 32),
          Text(
            'Alert Types',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(theme, 'Transfer Updates', 'Status of your money transfers', true),
          const SizedBox(height: 16),
          _buildSettingsTile(theme, 'Security Alerts', 'Login attempts and password changes', true),
          const SizedBox(height: 16),
          _buildSettingsTile(theme, 'Promotions', 'Offers and updates from Ahadu', false),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(ThemeData theme, String title, String subtitle, bool initialValue) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppPalette.borderLight),
      ),
      child: Row(
        children: [
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
          Switch(
            value: initialValue,
            onChanged: (val) {},
            activeColor: AppPalette.primary,
          ),
        ],
      ),
    );
  }
}
