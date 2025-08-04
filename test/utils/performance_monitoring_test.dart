import 'package:flutter_test/flutter_test.dart';
import 'package:athlete_iq/utils/performance_monitoring.dart';
import 'package:firebase_performance/firebase_performance.dart';

void main() {
  group('PerformanceMonitoring', () {
    test('isFirebaseInitialized returns false in test environment', () {
      expect(PerformanceMonitoring.isFirebaseInitialized, false);
    });

    test('startTrace returns MockTrace in test environment', () {
      final trace = PerformanceMonitoring.startTrace('test_trace');
      expect(trace, isA<MockTrace>());
    });

    test('startHttpMetric returns MockHttpMetric in test environment', () {
      final metric = PerformanceMonitoring.startHttpMetric('https://example.com', HttpMethod.Get);
      expect(metric, isA<MockHttpMetric>());
    });

    test('measureExecution calls function and returns its result', () async {
      bool functionCalled = false;
      final result = await PerformanceMonitoring.measureExecution('test_execution', () async {
        functionCalled = true;
        return 42;
      });
      
      expect(functionCalled, true);
      expect(result, 42);
    });

    test('measureExecutionSync calls function and returns its result', () {
      bool functionCalled = false;
      final result = PerformanceMonitoring.measureExecutionSync('test_execution_sync', () {
        functionCalled = true;
        return 'test_result';
      });
      
      expect(functionCalled, true);
      expect(result, 'test_result');
    });

    test('addAttribute adds attribute to trace', () {
      final trace = PerformanceMonitoring.startTrace('test_trace');
      PerformanceMonitoring.addAttribute(trace, 'test_key', 'test_value');
      
      // Since we're using a MockTrace, we can't directly verify the attribute
      // But we can verify that the method doesn't throw an exception
      expect(() => PerformanceMonitoring.addAttribute(trace, 'another_key', 'another_value'), 
          returnsNormally);
    });

    test('incrementMetric increments metric in trace', () {
      final trace = PerformanceMonitoring.startTrace('test_trace');
      PerformanceMonitoring.incrementMetric(trace, 'test_metric');
      PerformanceMonitoring.incrementMetric(trace, 'test_metric', 5);
      
      // Since we're using a MockTrace, we can't directly verify the metric
      // But we can verify that the method doesn't throw an exception
      expect(() => PerformanceMonitoring.incrementMetric(trace, 'another_metric', 10), 
          returnsNormally);
    });
  });

  group('MockTrace', () {
    test('can be created through PerformanceMonitoring.startTrace', () {
      final mockTrace = PerformanceMonitoring.startTrace('test_trace');
      expect(mockTrace, isA<MockTrace>());
    });
    
    test('methods work without throwing exceptions', () {
      final mockTrace = PerformanceMonitoring.startTrace('test_trace');
      
      // Test all methods
      expect(() => mockTrace.start(), returnsNormally);
      expect(() => mockTrace.stop(), returnsNormally);
      expect(() => mockTrace.putAttribute('key', 'value'), returnsNormally);
      expect(() => mockTrace.removeAttribute('key'), returnsNormally);
      expect(() => mockTrace.incrementMetric('metric', 1), returnsNormally);
      expect(() => mockTrace.setMetric('metric', 100), returnsNormally);
    });
  });

  group('MockHttpMetric', () {
    test('can be created through PerformanceMonitoring.startHttpMetric', () {
      final mockHttpMetric = PerformanceMonitoring.startHttpMetric('https://example.com', HttpMethod.Get);
      expect(mockHttpMetric, isA<MockHttpMetric>());
    });
    
    test('methods work without throwing exceptions', () {
      final mockHttpMetric = PerformanceMonitoring.startHttpMetric('https://example.com', HttpMethod.Get);
      
      // Test all methods
      expect(() => mockHttpMetric.start(), returnsNormally);
      expect(() => mockHttpMetric.stop(), returnsNormally);
      expect(() => mockHttpMetric.httpResponseCode = 200, returnsNormally);
      expect(() => mockHttpMetric.requestPayloadSize = 1024, returnsNormally);
      expect(() => mockHttpMetric.responseContentType = 'application/json', returnsNormally);
      expect(() => mockHttpMetric.responsePayloadSize = 2048, returnsNormally);
    });
  });
}