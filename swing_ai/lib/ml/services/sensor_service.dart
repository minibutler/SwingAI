import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart'; // Will require this dependency

// Class to represent gyroscope and accelerometer data point
class SensorDataPoint {
  final DateTime timestamp;
  final double gyroX;
  final double gyroY;
  final double gyroZ;
  final double accelX;
  final double accelY;
  final double accelZ;

  SensorDataPoint({
    required this.timestamp,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.accelX,
    required this.accelY,
    required this.accelZ,
  });

  @override
  String toString() {
    return 'SensorData(t: $timestamp, gyro: [$gyroX, $gyroY, $gyroZ], accel: [$accelX, $accelY, $accelZ])';
  }

  // Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'gyroX': gyroX,
      'gyroY': gyroY,
      'gyroZ': gyroZ,
      'accelX': accelX,
      'accelY': accelY,
      'accelZ': accelZ,
    };
  }

  // Create from map for retrieval
  factory SensorDataPoint.fromMap(Map<String, dynamic> map) {
    return SensorDataPoint(
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      gyroX: map['gyroX'],
      gyroY: map['gyroY'],
      gyroZ: map['gyroZ'],
      accelX: map['accelX'],
      accelY: map['accelY'],
      accelZ: map['accelZ'],
    );
  }
}

// Main class for sensor integration
class SensorService {
  static const int samplingRateHz = 100; // 100 Hz sampling rate

  StreamSubscription<GyroscopeEvent>? _gyroSubscription;
  StreamSubscription<AccelerometerEvent>? _accelSubscription;

  List<SensorDataPoint> _sensorData = [];
  bool _isRecording = false;

  // Singleton instance
  static final SensorService _instance = SensorService._internal();

  factory SensorService() {
    return _instance;
  }

  SensorService._internal();

  // Check if recording is in progress
  bool get isRecording => _isRecording;

  // Access collected data
  List<SensorDataPoint> get sensorData => _sensorData;

  // Start recording sensor data
  void startRecording() {
    if (_isRecording) {
      return;
    }

    _sensorData.clear();
    _isRecording = true;

    try {
      // Start gyroscope subscription
      _gyroSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
        _processGyroEvent(event);
      });

      // Start accelerometer subscription
      _accelSubscription =
          accelerometerEvents.listen((AccelerometerEvent event) {
        _processAccelEvent(event);
      });

      if (kDebugMode) {
        print('Started sensor recording');
      }
    } catch (e) {
      stopRecording();
      if (kDebugMode) {
        print('Error starting sensor recording: $e');
      }
    }
  }

  // Stop recording sensor data
  void stopRecording() {
    _isRecording = false;

    _gyroSubscription?.cancel();
    _accelSubscription?.cancel();

    _gyroSubscription = null;
    _accelSubscription = null;

    if (kDebugMode) {
      print(
          'Stopped sensor recording. Collected ${_sensorData.length} data points');
    }
  }

  // Variables to store most recent sensor readings
  double _lastGyroX = 0.0;
  double _lastGyroY = 0.0;
  double _lastGyroZ = 0.0;
  double _lastAccelX = 0.0;
  double _lastAccelY = 0.0;
  double _lastAccelZ = 0.0;
  DateTime _lastTimestamp = DateTime.now();

  // Process gyroscope event
  void _processGyroEvent(GyroscopeEvent event) {
    if (!_isRecording) return;

    _lastGyroX = event.x;
    _lastGyroY = event.y;
    _lastGyroZ = event.z;

    _tryAddDataPoint();
  }

  // Process accelerometer event
  void _processAccelEvent(AccelerometerEvent event) {
    if (!_isRecording) return;

    _lastAccelX = event.x;
    _lastAccelY = event.y;
    _lastAccelZ = event.z;
    _lastTimestamp = DateTime.now();

    _tryAddDataPoint();
  }

  // Add data point at sampling rate
  void _tryAddDataPoint() {
    // Only add a data point when we have both gyro and accel data
    // and at the desired sampling rate
    final now = DateTime.now();
    final timeSinceLastSample = now.difference(_lastTimestamp).inMilliseconds;

    // Ensure we're sampling at the right rate
    // (1000 / samplingRateHz = milliseconds between samples)
    if (timeSinceLastSample >= (1000 / samplingRateHz)) {
      _sensorData.add(
        SensorDataPoint(
          timestamp: now,
          gyroX: _lastGyroX,
          gyroY: _lastGyroY,
          gyroZ: _lastGyroZ,
          accelX: _lastAccelX,
          accelY: _lastAccelY,
          accelZ: _lastAccelZ,
        ),
      );

      _lastTimestamp = now;
    }
  }

  // Calculate swing speed from gyroscope data
  double calculateSwingSpeed() {
    if (_sensorData.isEmpty) {
      return 0.0;
    }

    // Find maximum angular velocity during downswing
    double maxAngularVelocity = 0.0;

    for (var data in _sensorData) {
      // Calculate magnitude of angular velocity
      final magnitude = _calculateMagnitude(data.gyroX, data.gyroY, data.gyroZ);

      if (magnitude > maxAngularVelocity) {
        maxAngularVelocity = magnitude;
      }
    }

    // Convert rad/s to mph using calibration factor
    // This factor would be calibrated against a professional launch monitor
    const double calibrationFactor = 2.23694; // rad/s to mph conversion

    return maxAngularVelocity * calibrationFactor;
  }

  // Calculate magnitude of a 3D vector
  double _calculateMagnitude(double x, double y, double z) {
    return math.sqrt(x * x + y * y + z * z);
  }
}
