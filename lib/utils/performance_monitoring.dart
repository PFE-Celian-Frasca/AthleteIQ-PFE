import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

class MockTrace implements Trace {
  final Map<String, String> _attributes = {};
  final Map<String, int> _metrics = {};

  MockTrace(name);

  @override
  Future<void> start()  {
    return Future.value();
  }

  @override
  Future<void> stop()  {
    return Future.value();
  }

  @override
  void putAttribute(String name, String value) {
    _attributes[name] = value;
  }

  @override
  void removeAttribute(String name) {
    _attributes.remove(name);
  }

  @override
  void incrementMetric(String name, int value) {
    _metrics[name] = (_metrics[name] ?? 0) + value;
  }

  @override
  void setMetric(String name, int value) {
    _metrics[name] = value;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockHttpMetric implements HttpMetric {

  MockHttpMetric(url,httpMethod);

  @override
  Future<void> start()  {
    return Future.value();
  }

  @override
  Future<void> stop()  {
    return Future.value();
  }

  @override
  set httpResponseCode(int? httpResponseCode) {}

  @override
  set requestPayloadSize(int? requestPayloadSize) {}

  @override
  set responseContentType(String? responseContentType) {}

  @override
  set responsePayloadSize(int? responsePayloadSize) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class PerformanceMonitoring {
  PerformanceMonitoring._();

  static bool get isFirebaseInitialized {
    try {
      Firebase.app();
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  static Trace startTrace(String name) {
    if (kDebugMode || !isFirebaseInitialized) {
      return MockTrace(name);
    }
    
    final trace = FirebasePerformance.instance.newTrace(name);
    trace.start();
    return trace;
  }

  static HttpMetric startHttpMetric(String url, HttpMethod method) {

    if (kDebugMode || !isFirebaseInitialized) {
      return MockHttpMetric(url, method);
    }
    
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