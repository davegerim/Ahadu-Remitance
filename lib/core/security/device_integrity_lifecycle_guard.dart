import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../router/app_router.dart';
import 'device_integrity_provider.dart';

/// Re-runs integrity checks when the app returns to the foreground.
class DeviceIntegrityLifecycleGuard extends ConsumerStatefulWidget {
  const DeviceIntegrityLifecycleGuard({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<DeviceIntegrityLifecycleGuard> createState() =>
      _DeviceIntegrityLifecycleGuardState();
}

class _DeviceIntegrityLifecycleGuardState
    extends ConsumerState<DeviceIntegrityLifecycleGuard>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _recheckIntegrity();
    }
  }

  Future<void> _recheckIntegrity() async {
    final result =
        await ref.read(deviceIntegrityServiceProvider).checkIntegrity();
    if (!mounted || !result.isCompromised) return;

    ref.invalidate(deviceIntegrityProvider);
    ref.read(appRouterProvider).go('/compromised-device');
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
