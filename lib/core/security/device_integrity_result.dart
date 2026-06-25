class DeviceIntegrityResult {
  const DeviceIntegrityResult({
    required this.isCompromised,
    required this.reasons,
  });

  final bool isCompromised;
  final List<String> reasons;

  factory DeviceIntegrityResult.secure() {
    return const DeviceIntegrityResult(isCompromised: false, reasons: []);
  }

  factory DeviceIntegrityResult.fromMap(Map<dynamic, dynamic> map) {
    final reasons = (map['reasons'] as List<dynamic>? ?? const [])
        .map((reason) => reason.toString())
        .toList();

    return DeviceIntegrityResult(
      isCompromised: map['compromised'] == true,
      reasons: reasons,
    );
  }
}
