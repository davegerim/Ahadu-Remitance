package com.ahadubank.ahadu_remittance

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.ahadubank.ahadu_remittance/device_integrity"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "checkIntegrity" -> {
                        result.success(DeviceIntegrityChecker.check(this))
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
