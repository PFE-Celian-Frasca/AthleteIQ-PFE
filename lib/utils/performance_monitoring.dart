import 'package:firebase_performance/firebase_performance.dart';

class PerformanceMonitoring {
  PerformanceMonitoring._();

  static Trace startTrace(String name) {
    final trace = FirebasePerformance.instance.newTrace(name);
    trace.start();
    return trace;
  }

  static HttpMetric startHttpMetric(String url, HttpMethod method) {
    final metric = FirebasePerformance.instance.newHttpMetric(url, method);
    metric.start();
    return metric;
  }

  static Future<T> measureExecution<T>(
    String name,
    Future<T> Function() function,
  ) async {
    final trace = startTrace(name);
    try {
      final result = await function();
      return result;
    } finally {
      await trace.stop();
    }
  }

  static T measureExecutionSync<T>(String name, T Function() function) {
    final trace = startTrace(name);
    try {
      final result = function();
      return result;
    } finally {
      trace.stop();
    }
  }

  static void addAttribute(Trace trace, String name, String value) {
    trace.putAttribute(name, value);
  }

  static void incrementMetric(Trace trace, String name, [int incrementBy = 1]) {
    trace.incrementMetric(name, incrementBy);
  }
}