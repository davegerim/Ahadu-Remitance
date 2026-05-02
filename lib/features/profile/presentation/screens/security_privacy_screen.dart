import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ahadu_remittance/core/theme/colors.dart';

class SecurityPrivacyScreen extends ConsumerWidget {
  const SecurityPrivacyScreen({super.key});

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
          'Security & Privacy',
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
          _buildSettingsTile(theme, 'Biometric Login', 'Use Face ID or Touch ID to login', LucideIcons.fingerprint, true),
          const SizedBox(height: 16),
          _buildSettingsTile(theme, 'Two-Factor Authentication', 'Add an extra layer of security', LucideIcons.shieldCheck, false),
          const SizedBox(height: 16),
          _buildSettingsTile(theme, 'Change Password', 'Update your account password', LucideIcons.key, false, isNav: true),
          const SizedBox(height: 16),
          _buildSettingsTile(theme, 'Device Management', 'Manage connected devices', LucideIcons.smartphone, false, isNav: true),
          const SizedBox(height: 32),
          Text(
            'Privacy',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(theme, 'Data Sharing', 'Manage how your data is shared', LucideIcons.share2, false, isNav: true),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(ThemeData theme, String title, String subtitle, IconData icon, bool hasSwitch, {bool isNav = false, bool isDestructive = false}) {
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
              color: isDestructive ? AppPalette.error.withValues(alpha: 0.1) : AppPalette.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: isDestructive ? AppPalette.error : AppPalette.primary, size: 24),
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
                    color: isDestructive ? AppPalette.error : AppPalette.textPrimary,
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
          if (hasSwitch)
            Switch(
              value: true,
              onChanged: (val) {},
              activeColor: AppPalette.primary,
            )
          else if (isNav)
            const Icon(LucideIcons.chevronRight, color: AppPalette.textHint),
        ],
      ),
    );
  }
}
