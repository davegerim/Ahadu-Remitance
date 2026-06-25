import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device_integrity_result.dart';
import 'device_integrity_service.dart';

final deviceIntegrityServiceProvider = Provider<DeviceIntegrityService>((ref) {
  return DeviceIntegrityService();
});

final deviceIntegrityProvider = FutureProvider<DeviceIntegrityResult>((ref) async {
  final service = ref.watch(deviceIntegrityServiceProvider);
  return service.checkIntegrity();
});
