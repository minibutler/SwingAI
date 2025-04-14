import 'dart:io';
import 'dart:math';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:uuid/uuid.dart';

import '../models/club.dart';
import '../models/swing_analysis.dart';
import '../utils/logger.dart';

class SwingAnalyzerService {
  late Interpreter _tfliteModel;
  final List<double> _gyroReadings = [];
  final double _calibrationFactor =
      1.5; // Calibration factor for gyroscope readings

  // Initialize the service
  Future<void> initialize() async {
    try {
      // Load the TensorFlow Lite model
      _tfliteModel = await Interpreter.fromAsset(
        'assets/models/swing_analyzer.tflite',
      );
      Logger.log('TensorFlow Lite model loaded successfully');
    } catch (e) {
      Logger.error('Error loading TensorFlow Lite model', e);
      throw Exception('Failed to load swing analyzer model');
    }

    // Start collecting gyroscope data
    _startGyroCollection();
  }

  // Start collecting gyroscope data
  void _startGyroCollection() {
    gyroscopeEventStream().listen((GyroscopeEvent event) {
      // Only collect z-axis rotational data (most relevant for swing)
      _gyroReadings.add(event.z);

      // Keep only the last 100 readings to prevent memory issues
      if (_gyroReadings.length > 100) {
        _gyroReadings.removeAt(0);
      }
    });
  }

  // Clear gyroscope readings before starting a new swing
  void clearGyroReadings() {
    _gyroReadings.clear();
  }

  // Get the highest z-axis rotation during swing (for swing speed calculation)
  double _getMaxGyroReading() {
    if (_gyroReadings.isEmpty) return 0.0;

    return _gyroReadings.reduce(max).abs();
  }

  // Analyze a golf swing from a video file
  Future<SwingAnalysis> analyzeSwing({
    required File videoFile,
    required Club club,
    required String userId,
    required double userHeightCm,
  }) async {
    try {
      // Extract keypoints from video using ML Kit pose detection
      final List<List<double>> keypoints = await _extractKeypointsFromVideo(
        videoFile,
      );

      // Use TensorFlow Lite to analyze the keypoints
      final swingData = await _analyzeKeypoints(keypoints);

      // Get gyroscope data for fusion
      final maxGyroReading = _getMaxGyroReading();

      // Calculate swing speed based on keypoints and gyroscope data
      final swingSpeedMph = _calculateSwingSpeed(
        keypoints,
        maxGyroReading,
        club,
        userHeightCm,
      );

      // Calculate ball speed based on swing speed and club's smash factor
      final ballSpeedMph = club.calculateBallSpeed(swingSpeedMph);

      // Calculate carry distance
      final carryDistanceYards = club.calculateCarryDistance(swingSpeedMph);

      // Detect swing errors
      final detectedErrors = _detectSwingErrors(swingData);

      // Generate a unique ID for this analysis
      final id = const Uuid().v4();

      // Create a temporary URL for the video
      // In a production app, you would upload this to Firebase Storage
      final videoUrl = videoFile.path;

      // Create and return the swing analysis
      return SwingAnalysis(
        id: id,
        timestamp: DateTime.now(),
        userId: userId,
        videoUrl: videoUrl,
        club: club,
        swingSpeedMph: swingSpeedMph,
        ballSpeedMph: ballSpeedMph,
        carryDistanceYards: carryDistanceYards,
        detectedErrors: detectedErrors,
        errorConfidence: swingData,
        accuracy: _calculateAccuracy(swingData),
      );
    } catch (e) {
      Logger.error('Error analyzing swing', e);
      throw Exception('Failed to analyze swing');
    }
  }

  // Extract keypoints from video using ML Kit pose detection
  Future<List<List<double>>> _extractKeypointsFromVideo(File videoFile) async {
    // This is a placeholder - for MVP purposes, we'll return mock data
    // In a real implementation, you would:
    // 1. Extract frames from the video
    // 2. Process each frame with Google ML Kit pose detection
    // 3. Convert the pose landmarks to a list of keypoints

    // Generate 30 frames of mock pose data (34 keypoints per frame)
    List<List<double>> mockKeypoints = List.generate(
      30,
      (frameIndex) => List.generate(
        34 * 3, // 34 keypoints, each with x, y, z coordinates
        (i) => 0.5 + 0.1 * sin(frameIndex / 10 + i / 5),
      ),
    );

    return mockKeypoints;
  }

  // Analyze keypoints using TensorFlow Lite
  Future<Map<String, double>> _analyzeKeypoints(
    List<List<double>> keypoints,
  ) async {
    // Prepare input for TensorFlow Lite
    // This is a simplified placeholder - in a real app, you would prepare the data
    // according to your model's requirements

    // Mock error detection results
    return {'overTheTop': 0.2, 'earlyExtension': 0.6, 'casting': 0.3};
  }

  // Calculate swing speed using keypoint data and gyroscope data
  double _calculateSwingSpeed(
    List<List<double>> keypoints,
    double maxGyroReading,
    Club club,
    double userHeightCm,
  ) {
    // This is a placeholder implementation based on the pseudocode in the blueprint
    // In a real app, this would be more sophisticated

    // Calculate wrist speed from keypoints
    double wristSpeedPx = 0.0;

    if (keypoints.length >= 20) {
      // Use the last 20 frames to calculate speed
      final lastFrames = keypoints.sublist(keypoints.length - 20);
      final tenthLastFrame = lastFrames[9];
      final lastFrame = lastFrames[19];

      // Calculate movement of right wrist keypoint (index 16)
      double dx = 0.0, dy = 0.0, dz = 0.0;

      // Assuming 3 values per keypoint (x, y, z)
      final wristBaseIndex = 16 * 3;
      dx = lastFrame[wristBaseIndex] - tenthLastFrame[wristBaseIndex];
      dy = lastFrame[wristBaseIndex + 1] - tenthLastFrame[wristBaseIndex + 1];
      dz = lastFrame[wristBaseIndex + 2] - tenthLastFrame[wristBaseIndex + 2];

      // Calculate Euclidean distance
      wristSpeedPx = sqrt(dx * dx + dy * dy + dz * dz);
    }

    // Convert gyro reading to a speed value
    final gyroSpeed = maxGyroReading * _calibrationFactor;

    // Fuse both measurements (simple average for now)
    double fusedSpeed = (wristSpeedPx + gyroSpeed) / 2;

    // Adjust based on user height and club length
    final clubLengthM = club.calculateLength(userHeightCm);
    fusedSpeed *= (clubLengthM / 1.0); // Adjust for a 1-meter reference club

    // Convert to mph (arbitrary conversion for mock purposes)
    // In a real app, this would be properly calibrated
    double swingSpeedMph = fusedSpeed * 50;

    // Realistic range for swing speeds based on club type
    double minSpeed = 0.0;
    double maxSpeed = 0.0;

    switch (club.id) {
      case 'driver':
        minSpeed = 80.0;
        maxSpeed = 120.0;
        break;
      case 'iron7':
        minSpeed = 70.0;
        maxSpeed = 90.0;
        break;
      case 'pw':
        minSpeed = 60.0;
        maxSpeed = 80.0;
        break;
      default:
        minSpeed = 60.0;
        maxSpeed = 120.0;
    }

    // Clamp to realistic range with some randomness for demo purposes
    final random = Random();
    swingSpeedMph =
        swingSpeedMph.clamp(minSpeed, maxSpeed) +
        random.nextDouble() * 5.0 -
        2.5;

    return double.parse(swingSpeedMph.toStringAsFixed(1));
  }

  // Detect swing errors from analysis data
  List<SwingError> _detectSwingErrors(Map<String, double> swingData) {
    const double threshold = 0.5;
    final List<SwingError> errors = [];

    if (swingData['overTheTop'] != null &&
        swingData['overTheTop']! >= threshold) {
      errors.add(SwingError.overTheTop);
    }

    if (swingData['earlyExtension'] != null &&
        swingData['earlyExtension']! >= threshold) {
      errors.add(SwingError.earlyExtension);
    }

    if (swingData['casting'] != null && swingData['casting']! >= threshold) {
      errors.add(SwingError.casting);
    }

    if (errors.isEmpty) {
      errors.add(SwingError.none);
    }

    return errors;
  }

  // Calculate overall swing accuracy
  double _calculateAccuracy(Map<String, double> swingData) {
    // Simple accuracy calculation for MVP
    // In a real app, this would be more sophisticated
    double errorSum = 0.0;
    swingData.forEach((_, value) => errorSum += value);

    // Calculate accuracy as inverse of average error
    double accuracy = 100.0 - (errorSum / swingData.length) * 100.0;

    // Ensure accuracy is between 0-100
    return accuracy.clamp(0.0, 100.0);
  }

  // Dispose resources when no longer needed
  void dispose() {
    _tfliteModel.close();
  }
}
