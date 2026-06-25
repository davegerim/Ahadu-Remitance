import Darwin
import Foundation
import UIKit

enum DeviceIntegrityChecker {
  private static let jailbreakPaths = [
    "/Applications/Cydia.app",
    "/Applications/Sileo.app",
    "/Applications/Zebra.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt",
    "/private/var/lib/apt/",
    "/private/var/lib/cydia",
    "/private/var/stash",
    "/private/var/tmp/cydia.log",
    "/usr/bin/ssh",
    "/usr/libexec/sftp-server",
    "/var/cache/apt",
    "/var/lib/dpkg",
  ]

  private static let suspiciousSchemes = [
    "cydia://",
    "sileo://",
    "zbra://",
    "filza://",
  ]

  static func check() -> [String: Any] {
    var reasons: [String] = []

    if isSimulator() {
      reasons.append("emulator")
    }
    if isDebuggerAttached() {
      reasons.append("debugger_attached")
    }
    if hasJailbreakFiles() {
      reasons.append("jailbreak_files")
    }
    if canWriteOutsideSandbox() {
      reasons.append("sandbox_violation")
    }
    if hasSuspiciousSchemes() {
      reasons.append("jailbreak_schemes")
    }
    if hasSuspiciousEnvironment() {
      reasons.append("suspicious_environment")
    }

    return [
      "compromised": !reasons.isEmpty,
      "reasons": reasons,
    ]
  }

  private static func isSimulator() -> Bool {
    #if targetEnvironment(simulator)
      return true
    #else
      return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    #endif
  }

  private static func isDebuggerAttached() -> Bool {
    var info = kinfo_proc()
    var size = MemoryLayout<kinfo_proc>.stride
    var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]

    let result = sysctl(&mib, u_int(mib.count), &info, &size, nil, 0)
    if result != 0 {
      return false
    }

    return (info.kp_proc.p_flag & P_TRACED) != 0
  }

  private static func hasJailbreakFiles() -> Bool {
    jailbreakPaths.contains { FileManager.default.fileExists(atPath: $0) }
  }

  private static func canWriteOutsideSandbox() -> Bool {
    let testPath = "/private/ahadu_jailbreak_test.txt"
    do {
      try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
      try FileManager.default.removeItem(atPath: testPath)
      return true
    } catch {
      return false
    }
  }

  private static func hasSuspiciousSchemes() -> Bool {
    suspiciousSchemes.contains { scheme in
      guard let url = URL(string: scheme) else { return false }
      return UIApplication.shared.canOpenURL(url)
    }
  }

  private static func hasSuspiciousEnvironment() -> Bool {
    if getenv("DYLD_INSERT_LIBRARIES") != nil {
      return true
    }
    if getenv("MSSafeMode") != nil {
      return true
    }
    return false
  }
}
