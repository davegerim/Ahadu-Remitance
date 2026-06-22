import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:ahadu_remittance/core/theme/colors.dart';
import 'package:ahadu_remittance/features/auth/data/repositories/auth_repository.dart';
import 'package:ahadu_remittance/features/auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentCustomerProvider.notifier).fetchProfile();
    });
  }

  Future<void> _handleLogout() async {
    await ref.read(authRepositoryProvider).logout();
    ref.read(currentCustomerProvider.notifier).clearCustomer();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customerAsync = ref.watch(currentCustomerProvider);

    return Scaffold(
      backgroundColor: AppPalette.background,
      appBar: AppBar(title: const Text('Profile'), elevation: 0),
      body: customerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Failed to load profile',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(currentCustomerProvider.notifier).fetchProfile();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (customer) {
          final name = customer?.fullName ?? 'User';
          final email = customer?.email ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: 120,
            ),
            child: Column(
              children: [
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
                      Text(name, style: theme.textTheme.displayMedium),
                      const SizedBox(height: 4),
                      Text(email, style: theme.textTheme.bodyMedium),
                      if (customer?.phone != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          customer!.phone,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppPalette.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                _buildSectionHeader(theme, 'Account Settings'),
                _buildListTile(
                  context,
                  theme,
                  'Security & Privacy',
                  LucideIcons.shield,
                  '/security-privacy',
                ),
                const SizedBox(height: 32),
                _buildSectionHeader(theme, 'Preferences'),
                _buildListTile(
                  context,
                  theme,
                  'Notifications',
                  LucideIcons.bell,
                  '/settings-notifications',
                ),
                _buildListTile(
                  context,
                  theme,
                  'Language',
                  LucideIcons.globe,
                  '/language',
                ),
                const SizedBox(height: 32),
                _buildSectionHeader(theme, 'Support'),
                _buildListTile(
                  context,
                  theme,
                  'Help Center',
                  LucideIcons.helpCircle,
                  '/help-center',
                ),
                _buildListTile(
                  context,
                  theme,
                  'Terms of Service',
                  LucideIcons.fileText,
                  '/terms-of-service',
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _handleLogout,
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
          );
        },
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

  Widget _buildListTile(
    BuildContext context,
    ThemeData theme,
    String title,
    IconData icon,
    String? route,
  ) {
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
        onTap: () {
          if (route != null) {
            context.go(route);
          }
        },
      ),
    );
  }
}
