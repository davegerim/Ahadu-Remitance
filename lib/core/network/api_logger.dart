import 'dart:convert';
import 'package:flutter/foundation.dart';

class ApiLogger {
  static void logRequest({
    required String apiName,
    required String method,
    required String url,
    Map<String, dynamic>? payload,
  }) {
    final buffer = StringBuffer()
      ..writeln('')
      ..writeln('╔══════════════════════════════════════════════════════════')
      ..writeln('║ API REQUEST: $apiName')
      ..writeln('╠══════════════════════════════════════════════════════════')
      ..writeln('║ Method: $method')
      ..writeln('║ URL: $url');

    if (payload != null) {
      buffer
        ..writeln('║ Payload:')
        ..writeln(_indentJson(payload));
    }

    buffer.writeln('╚══════════════════════════════════════════════════════════');
    debugPrint(buffer.toString());
  }

  static void logResponse({
    required String apiName,
    required int statusCode,
    dynamic data,
  }) {
    final buffer = StringBuffer()
      ..writeln('')
      ..writeln('╔══════════════════════════════════════════════════════════')
      ..writeln('║ API RESPONSE: $apiName')
      ..writeln('╠══════════════════════════════════════════════════════════')
      ..writeln('║ Status Code: $statusCode')
      ..writeln('║ Response Body:')
      ..writeln(_indentJson(data))
      ..writeln('╚══════════════════════════════════════════════════════════');
    debugPrint(buffer.toString());
  }

  static void logError({
    required String apiName,
    required String message,
    int? statusCode,
    dynamic data,
  }) {
    final buffer = StringBuffer()
      ..writeln('')
      ..writeln('╔══════════════════════════════════════════════════════════')
      ..writeln('║ API ERROR: $apiName')
      ..writeln('╠══════════════════════════════════════════════════════════')
      ..writeln('║ Message: $message');

    if (statusCode != null) {
      buffer.writeln('║ Status Code: $statusCode');
    }

    if (data != null) {
      buffer
        ..writeln('║ Error Body:')
        ..writeln(_indentJson(data));
    }

    buffer.writeln('╚══════════════════════════════════════════════════════════');
    debugPrint(buffer.toString());
  }

  static String _indentJson(dynamic data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      if (data is Map || data is List) {
        return encoder.convert(data).split('\n').map((line) => '║   $line').join('\n');
      }
      return '║   $data';
    } catch (_) {
      return '║   $data';
    }
  }
}
