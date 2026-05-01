import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/walkthrough_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/remittance/presentation/screens/send_money_screen.dart';
import '../../features/remittance/presentation/screens/recipient_selection_screen.dart';
import '../../features/remittance/presentation/screens/review_transfer_screen.dart';
import '../../features/remittance/presentation/screens/success_screen.dart';
import '../../features/remittance/presentation/screens/failure_screen.dart';
import '../../features/transactions/presentation/screens/transactions_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/donate/presentation/screens/donate_screen.dart';
import '../../features/cards/presentation/screens/cards_screen.dart';
import '../../features/support/presentation/screens/support_screen.dart';
import 'package:ahadu_remittance/core/theme/colors.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/walkthrough',
        builder: (context, state) => const WalkthroughScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithBottomNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/send',
            builder: (context, state) => const SendMoneyScreen(),
          ),
          GoRoute(
            path: '/recipient',
            builder: (context, state) => const RecipientSelectionScreen(),
          ),
          GoRoute(
            path: '/review',
            builder: (context, state) => const ReviewTransferScreen(),
          ),
          GoRoute(
            path: '/success',
            builder: (context, state) => const SuccessScreen(),
          ),
          GoRoute(
            path: '/failure',
            builder: (context, state) => const FailureScreen(),
          ),
          GoRoute(
            path: '/donate',
            builder: (context, state) => const DonateScreen(),
          ),
          GoRoute(
            path: '/cards',
            builder: (context, state) => const CardsScreen(),
          ),
          GoRoute(
            path: '/support',
            builder: (context, state) => const SupportScreen(),
          ),
          GoRoute(
            path: '/transactions',
            builder: (context, state) => const TransactionsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});

class ScaffoldWithBottomNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithBottomNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);
    
    // Hide bottom nav on specific screens
    final String location = GoRouterState.of(context).uri.path;
    final bool hideNav = location.startsWith('/send') || 
                         location.startsWith('/recipient') || 
                         location.startsWith('/review') || 
                         location.startsWith('/success') ||
                         location.startsWith('/failure') ||
                         location.startsWith('/donate') ||
                         location.startsWith('/cards') ||
                         location.startsWith('/support');

    return Scaffold(
      backgroundColor: AppPalette.background,
      extendBody: true, // Allows content to scroll behind the floating nav bar
      body: child,
      bottomNavigationBar: hideNav ? null : SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: AppPalette.surfaceDark, // Deep dark floating bar
            image: DecorationImage(
              image: const AssetImage('assets/images/ahadu_tilet.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                AppPalette.surfaceDark.withValues(alpha: 0.85),
                BlendMode.darken,
              ),
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: LucideIcons.home,
                label: 'Home',
                isSelected: currentIndex == 0,
                onTap: () => context.go('/home'),
              ),
              _NavBarItem(
                icon: LucideIcons.arrowRightLeft,
                label: 'Transfer',
                isSelected: currentIndex == 1,
                onTap: () => context.go('/send'),
              ),
              _NavBarItem(
                icon: LucideIcons.history,
                label: 'History',
                isSelected: currentIndex == 2,
                onTap: () => context.go('/transactions'),
              ),
              _NavBarItem(
                icon: LucideIcons.user,
                label: 'Profile',
                isSelected: currentIndex == 3,
                onTap: () => context.go('/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/send') || location.startsWith('/recipient') || location.startsWith('/review') || location.startsWith('/success')) return 1;
    if (location.startsWith('/transactions')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppPalette.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white54,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
