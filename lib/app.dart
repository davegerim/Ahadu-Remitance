import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/security/device_integrity_lifecycle_guard.dart';
import 'core/theme/app_theme.dart';

class AhaduRemittanceApp extends ConsumerWidget {
  const AhaduRemittanceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return DeviceIntegrityLifecycleGuard(
      child: MaterialApp.router(
        title: 'Ahadu Remittance',
        theme: AppTheme.lightTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
