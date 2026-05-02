import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ahadu_remittance/core/theme/colors.dart';

class NotificationListScreen extends ConsumerWidget {
  const NotificationListScreen({super.key});

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
          onPressed: () => context.go('/home'),
        ),
        title: Text(
          'Notifications',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppPalette.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final isUnread = index < 2;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUnread ? AppPalette.primaryLight : AppPalette.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isUnread ? AppPalette.primary.withValues(alpha: 0.3) : AppPalette.borderLight,
              ),
              boxShadow: [
                if (isUnread)
                  BoxShadow(
                    color: AppPalette.primary.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUnread ? AppPalette.primary.withValues(alpha: 0.1) : AppPalette.background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    index % 2 == 0 ? LucideIcons.bellRing : LucideIcons.checkCircle,
                    color: isUnread ? AppPalette.primary : AppPalette.textSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        index % 2 == 0 ? 'Transfer Successful' : 'Security Alert',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600,
                          color: AppPalette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        index % 2 == 0 
                          ? 'Your transfer of \$150 to Dawit has been successfully completed.'
                          : 'A new login was detected from a new device.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppPalette.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '2 hours ago',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppPalette.textHint,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isUnread)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppPalette.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
