# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep MethodChannel entry points while allowing R8 to obfuscate internals.
-keep class com.ahadubank.ahadu_remittance.MainActivity { *; }

# Obfuscate integrity checker implementation details.
-keep,allowobfuscation class com.ahadubank.ahadu_remittance.DeviceIntegrityChecker { *; }

# Replace original source file names in release bytecode (audit #8).
-renamesourcefileattribute SourceFile

# Flutter deferred components reference Play Core optionally at runtime.
-dontwarn com.google.android.play.core.**

# Xposed class probe in DeviceIntegrityChecker; not bundled in the app.
-dontwarn de.robv.android.xposed.**
