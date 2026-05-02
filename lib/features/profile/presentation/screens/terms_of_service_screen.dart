import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ahadu_remittance/core/theme/colors.dart';

class TermsOfServiceScreen extends ConsumerWidget {
  const TermsOfServiceScreen({super.key});

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
          'Terms of Service',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppPalette.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppPalette.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppPalette.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last Updated: May 2, 2026',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppPalette.textHint,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              _buildParagraph(theme, '1. Acceptance of Terms', 'By accessing or using the Ahadu Remittance application, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our services.'),
              const SizedBox(height: 24),
              _buildParagraph(theme, '2. Description of Service', 'Ahadu provides a platform for users to send money internationally. We are not a bank, but a money transmitter. Services are subject to limits, delays, and compliance requirements.'),
              const SizedBox(height: 24),
              _buildParagraph(theme, '3. User Accounts', 'You are responsible for maintaining the confidentiality of your account credentials. You must immediately notify us of any unauthorized use of your account.'),
              const SizedBox(height: 24),
              _buildParagraph(theme, '4. Privacy Policy', 'Your use of Ahadu is also governed by our Privacy Policy, which outlines how we collect, use, and protect your personal information.'),
              const SizedBox(height: 24),
              _buildParagraph(theme, '5. Limitations of Liability', 'Ahadu shall not be liable for any indirect, incidental, special, or consequential damages resulting from the use or inability to use our services.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParagraph(ThemeData theme, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppPalette.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
