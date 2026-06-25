import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'device_integrity_provider.dart';

Future<bool> ensureDeviceSecure(WidgetRef ref, BuildContext context) async {
  final result = await ref.read(deviceIntegrityServiceProvider).checkIntegrity();
  if (!result.isCompromised) {
    return true;
  }

  ref.invalidate(deviceIntegrityProvider);

  if (context.mounted) {
    context.go('/compromised-device');
  }
  return false;
}
