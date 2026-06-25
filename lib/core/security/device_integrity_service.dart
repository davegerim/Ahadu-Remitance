import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'device_integrity_result.dart';

class DeviceIntegrityService {
  DeviceIntegrityService({MethodChannel? channel})
      : _channel = channel ??
            const MethodChannel('com.ahadubank.ahadu_remittance/device_integrity');

  final MethodChannel _channel;

  Future<DeviceIntegrityResult> checkIntegrity() async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return DeviceIntegrityResult.secure();
    }

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('checkIntegrity');
      if (result == null) {
        return const DeviceIntegrityResult(
          isCompromised: true,
          reasons: ['integrity_check_failed'],
        );
      }
      return DeviceIntegrityResult.fromMap(result);
    } on PlatformException {
      return const DeviceIntegrityResult(
        isCompromised: true,
        reasons: ['integrity_check_failed'],
      );
    } catch (_) {
      return const DeviceIntegrityResult(
        isCompromised: true,
        reasons: ['integrity_check_failed'],
      );
    }
  }
}
