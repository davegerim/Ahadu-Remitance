import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:ahadu_remittance/core/theme/colors.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppPalette.background,
      appBar: AppBar(title: const Text('Profile'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: 120,
        ), // Padding for nav bar
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://i.pravatar.cc/150?img=11',
                            ),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: AppPalette.border,
                            width: 2,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppPalette.surfaceDark,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppPalette.surface,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            LucideIcons.camera,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Dawit Gerim', style: theme.textTheme.displayMedium),
                  const SizedBox(height: 4),
                  Text('dawit@ahadu.com', style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Settings List
            _buildSectionHeader(theme, 'Account Settings'),
            _buildListTile(theme, 'Personal Information', LucideIcons.user),
            _buildListTile(theme, 'Payment Methods', LucideIcons.creditCard),
            _buildListTile(theme, 'Security & Privacy', LucideIcons.shield),

            const SizedBox(height: 32),
            _buildSectionHeader(theme, 'Preferences'),
            _buildListTile(theme, 'Notifications', LucideIcons.bell),
            _buildListTile(theme, 'Language', LucideIcons.globe),

            const SizedBox(height: 32),
            _buildSectionHeader(theme, 'Support'),
            _buildListTile(theme, 'Help Center', LucideIcons.helpCircle),
            _buildListTile(theme, 'Terms of Service', LucideIcons.fileText),

            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(LucideIcons.logOut, size: 20),
                label: const Text('Log Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppPalette.error,
                  side: const BorderSide(color: AppPalette.error, width: 1.5),
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
      padding: const EdgeInsets.only(bottom: 16, left: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppPalette.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(ThemeData theme, String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppPalette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppPalette.borderLight, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppPalette.background,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppPalette.textPrimary, size: 20),
        ),
        title: Text(title, style: theme.textTheme.titleMedium),
        trailing: const Icon(
          LucideIcons.chevronRight,
          color: AppPalette.textSecondary,
          size: 20,
        ),
        onTap: () {},
      ),
    );
  }
}
