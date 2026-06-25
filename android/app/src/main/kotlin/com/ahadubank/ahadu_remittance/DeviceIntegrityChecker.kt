package com.ahadubank.ahadu_remittance

import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Build
import android.os.Debug
import android.telephony.TelephonyManager
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader
import java.net.InetSocketAddress
import java.net.Socket

object DeviceIntegrityChecker {

    private val suBinaryPaths = listOf(
        "/system/bin/su",
        "/system/xbin/su",
        "/sbin/su",
        "/system/bin/.ext/su",
        "/system/xbin/mu",
        "/data/local/xbin/su",
        "/data/local/bin/su",
        "/data/local/su",
    )

    private val rootPackages = listOf(
        "com.topjohnwu.magisk",
        "com.koushikdutta.superuser",
        "eu.chainfire.supersu",
        "com.noshufou.android.su",
        "com.thirdparty.superuser",
        "com.yellowes.su",
        "com.kingroot.kinguser",
        "com.kingo.root",
    )

    private val emulatorFiles = listOf(
        "/dev/qemu_pipe",
        "/dev/socket/qemud",
        "/dev/socket/genyd",
        "/dev/socket/baseband_genyd",
        "/system/lib/libc_malloc_debug_qemu.so",
        "/sys/qemu_trace",
        "/system/bin/qemu-props",
        "/init.goldfish.rc",
        "/init.ranchu.rc",
    )

    private val fridaArtifacts = listOf(
        "/data/local/tmp/frida-server",
        "/data/local/tmp/re.frida.server",
        "/sdcard/frida-server",
    )

    private val hookArtifacts = listOf(
        "/system/framework/XposedBridge.jar",
        "/system/lib/libxposed_art.so",
        "/system/lib64/libxposed_art.so",
    )

    private val fridaPorts = listOf(27042, 27043)

    private val emulatorHardware = setOf(
        "goldfish",
        "ranchu",
        "vbox86",
        "vbox86p",
        "nox",
        "ttvm_x86",
        "sdk",
        "sdk_x86",
        "sdk_gphone",
    )

    fun check(context: Context): Map<String, Any> {
        val reasons = mutableListOf<String>()

        if (hasSuBinary()) reasons.add("su_binary")
        if (hasTestKeys()) reasons.add("test_keys")
        if (hasRootPackages(context)) reasons.add("root_packages")
        if (isSystemDebuggable()) reasons.add("debuggable")
        if (isAppDebuggable(context)) reasons.add("app_debuggable")
        if (isDebuggerAttached()) reasons.add("debugger_attached")
        if (hasFridaServer()) reasons.add("frida_server")
        if (hasFridaArtifacts()) reasons.add("frida_artifacts")
        if (isFridaPortOpen()) reasons.add("frida_port")
        if (hasNativeHooks()) reasons.add("native_hooks")
        if (hasXposed()) reasons.add("xposed_hooks")
        if (canExecuteSu()) reasons.add("su_executable")
        if (hasDangerousSystemProperties()) reasons.add("dangerous_props")
        if (isEmulator(context)) reasons.add("emulator")

        return mapOf(
            "compromised" to reasons.isNotEmpty(),
            "reasons" to reasons,
        )
    }

    private fun hasSuBinary(): Boolean =
        suBinaryPaths.any { path -> File(path).exists() }

    private fun hasTestKeys(): Boolean {
        val tags = Build.TAGS ?: return false
        return tags.contains("test-keys")
    }

    private fun hasRootPackages(context: Context): Boolean {
        val packageManager = context.packageManager
        return rootPackages.any { packageName ->
            try {
                packageManager.getPackageInfo(packageName, 0)
                true
            } catch (_: PackageManager.NameNotFoundException) {
                false
            }
        }
    }

    private fun isSystemDebuggable(): Boolean =
        readSystemProperty("ro.debuggable") == "1"

    private fun isAppDebuggable(context: Context): Boolean {
        return try {
            val flags = context.applicationInfo.flags
            flags and ApplicationInfo.FLAG_DEBUGGABLE != 0
        } catch (_: Exception) {
            false
        }
    }

    private fun isDebuggerAttached(): Boolean {
        if (Debug.isDebuggerConnected()) return true
        if (Debug.waitingForDebugger()) return true
        return hasTracerPid()
    }

    private fun hasTracerPid(): Boolean {
        return try {
            File("/proc/self/status").useLines { lines ->
                lines.any { line ->
                    if (line.startsWith("TracerPid:")) {
                        val pid = line.substringAfter(":").trim().toIntOrNull() ?: 0
                        return@useLines pid != 0
                    }
                    false
                }
            }
        } catch (_: Exception) {
            false
        }
    }

    private fun hasDangerousSystemProperties(): Boolean {
        val dangerousProps = mapOf(
            "ro.secure" to "0",
            "ro.debuggable" to "1",
        )

        return dangerousProps.any { (prop, dangerousValue) ->
            readSystemProperty(prop) == dangerousValue
        }
    }

    private fun readSystemProperty(name: String): String? {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("getprop", name))
            val value = process.inputStream.bufferedReader().use { it.readLine()?.trim() }
            process.waitFor()
            value
        } catch (_: Exception) {
            null
        }
    }

    private fun isEmulator(context: Context): Boolean {
        if (hasEmulatorBuildProperties()) return true
        if (hasEmulatorSystemProperties()) return true
        if (hasEmulatorFiles()) return true
        if (hasSuspiciousTelephony(context)) return true
        return false
    }

    private fun hasEmulatorBuildProperties(): Boolean {
        val fingerprint = Build.FINGERPRINT.lowercase()
        val model = Build.MODEL.lowercase()
        val manufacturer = Build.MANUFACTURER.lowercase()
        val product = Build.PRODUCT.lowercase()
        val hardware = Build.HARDWARE.lowercase()
        val brand = Build.BRAND.lowercase()
        val device = Build.DEVICE.lowercase()

        if (fingerprint.startsWith("generic") || fingerprint.startsWith("unknown")) return true
        if (model.contains("google_sdk") || model.contains("emulator") ||
            model.contains("android sdk built for x86")
        ) {
            return true
        }
        if (manufacturer.contains("genymotion") || manufacturer.contains("netease")) return true
        if (product.contains("sdk") || product.contains("emulator") || product.contains("simulator")) {
            return true
        }
        if (hardware in emulatorHardware) return true
        if (brand.startsWith("generic") && device.startsWith("generic")) return true

        return false
    }

    private fun hasEmulatorSystemProperties(): Boolean {
        if (readSystemProperty("ro.kernel.qemu") == "1") return true

        val suspiciousValues = listOf(
            readSystemProperty("ro.hardware"),
            readSystemProperty("ro.product.device"),
            readSystemProperty("ro.product.model"),
        )
        return suspiciousValues.any { value ->
            val normalized = value?.lowercase() ?: return@any false
            normalized.contains("goldfish") ||
                normalized.contains("ranchu") ||
                normalized.contains("vbox") ||
                normalized.contains("nox") ||
                normalized.contains("sdk") ||
                normalized.contains("emulator") ||
                normalized.contains("genymotion")
        }
    }

    private fun hasEmulatorFiles(): Boolean =
        emulatorFiles.any { path -> File(path).exists() }

    private fun hasSuspiciousTelephony(context: Context): Boolean {
        return try {
            val telephony =
                context.getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager
                    ?: return false

            val operatorName = telephony.networkOperatorName
            if (operatorName.equals("Android", ignoreCase = true)) return true

            val simOperator = telephony.simOperatorName
            if (simOperator.equals("Android", ignoreCase = true)) return true

            @Suppress("DEPRECATION")
            val deviceId = telephony.deviceId
            if (!deviceId.isNullOrBlank() && deviceId == "000000000000000") return true

            false
        } catch (_: Exception) {
            false
        }
    }

    private fun hasFridaServer(): Boolean {
        if (hasFridaInProcessMaps()) return true
        return hasFridaInProcCmdline()
    }

    private fun hasFridaInProcessMaps(): Boolean {
        return containsSuspiciousMapEntry { line ->
            line.contains("frida", ignoreCase = true) ||
                line.contains("gadget", ignoreCase = true)
        }
    }

    private fun hasNativeHooks(): Boolean {
        if (containsSuspiciousMapEntry { line ->
                line.contains("substrate", ignoreCase = true) ||
                    line.contains("substratehook", ignoreCase = true)
            }
        ) {
            return true
        }
        return hookArtifacts.any { path -> File(path).exists() }
    }

    private fun hasXposed(): Boolean {
        if (containsSuspiciousMapEntry { line ->
                line.contains("xposed", ignoreCase = true) ||
                    line.contains("lsposed", ignoreCase = true) ||
                    line.contains("edxposed", ignoreCase = true) ||
                    line.contains("xposedbridge", ignoreCase = true)
            }
        ) {
            return true
        }

        return try {
            Class.forName("de.robv.android.xposed.XposedBridge")
            true
        } catch (_: ClassNotFoundException) {
            false
        } catch (_: Exception) {
            false
        }
    }

    private fun containsSuspiciousMapEntry(predicate: (String) -> Boolean): Boolean {
        return try {
            val maps = File("/proc/self/maps")
            if (!maps.exists()) return false
            maps.useLines { lines -> lines.any(predicate) }
        } catch (_: Exception) {
            false
        }
    }

    private fun hasFridaInProcCmdline(): Boolean {
        return try {
            val procDir = File("/proc")
            val entries = procDir.listFiles() ?: return false
            entries.any { entry ->
                if (!entry.isDirectory || !entry.name.all { it.isDigit() }) return@any false
                val cmdline = File(entry, "cmdline")
                if (!cmdline.exists()) return@any false
                val processName = cmdline.readText().trim('\u0000', ' ')
                processName.contains("frida-server", ignoreCase = true) ||
                    processName.contains("frida", ignoreCase = true)
            }
        } catch (_: Exception) {
            false
        }
    }

    private fun hasFridaArtifacts(): Boolean =
        fridaArtifacts.any { path -> File(path).exists() }

    private fun isFridaPortOpen(): Boolean {
        return fridaPorts.any { port ->
            try {
                Socket().use { socket ->
                    socket.connect(InetSocketAddress("127.0.0.1", port), 200)
                    true
                }
            } catch (_: Exception) {
                false
            }
        }
    }

    private fun canExecuteSu(): Boolean {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("which", "su"))
            val output = BufferedReader(InputStreamReader(process.inputStream))
                .use { it.readLine() }
            process.waitFor()
            !output.isNullOrBlank()
        } catch (_: Exception) {
            false
        }
    }
}
