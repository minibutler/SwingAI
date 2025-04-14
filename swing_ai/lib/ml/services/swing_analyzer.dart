import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:swing_ai/ml/utils/pose_detection.dart';
import 'package:swing_ai/models/club.dart';
import 'package:swing_ai/models/swing_data.dart';

// Enum for swing errors that can be detected
enum SwingError {
  overTheTop,
  earlyExtension,
  casting,
  swayingHips,
  lossOfPosture,
  liftingHead,
  armCollapse,
  overswing,
  chickenwing
}

// Extension for SwingError that converts enum to readable string
extension SwingErrorExtension on SwingError {
  String get label {
    switch (this) {
      case SwingError.overTheTop:
        return 'Over-the-top';
      case SwingError.earlyExtension:
        return 'Early Extension';
      case SwingError.casting:
        return 'Casting';
      case SwingError.swayingHips:
        return 'Swaying Hips';
      case SwingError.lossOfPosture:
        return 'Loss of Posture';
      case SwingError.liftingHead:
        return 'Lifting Head';
      case SwingError.armCollapse:
        return 'Arm Collapse';
      case SwingError.overswing:
        return 'Overswing';
      case SwingError.chickenwing:
        return 'Chicken Wing';
    }
  }

  String get description {
    switch (this) {
      case SwingError.overTheTop:
        return 'Club moves outside the ideal swing plane on the downswing';
      case SwingError.earlyExtension:
        return 'Hips move toward the ball before impact';
      case SwingError.casting:
        return 'Early uncocking of wrists, losing lag angle on downswing';
      case SwingError.swayingHips:
        return 'Excessive lateral hip movement during backswing';
      case SwingError.lossOfPosture:
        return 'Spine angle changes significantly during swing';
      case SwingError.liftingHead:
        return 'Head lifts up before impact or during follow-through';
      case SwingError.armCollapse:
        return 'Right elbow (for right-handed golfer) breaks down on backswing';
      case SwingError.overswing:
        return 'Club goes beyond parallel at the top of backswing';
      case SwingError.chickenwing:
        return 'Left elbow (for right-handed golfer) bends during follow-through';
    }
  }

  String get fix {
    switch (this) {
      case SwingError.overTheTop:
        return 'Practice swinging on an inside-out path. Imagine throwing the club head out to right field.';
      case SwingError.earlyExtension:
        return 'Keep your tailbone pointed at the target line longer through impact.';
      case SwingError.casting:
        return 'Maintain wrist angle longer. Feel like your hands lead the clubhead into impact.';
      case SwingError.swayingHips:
        return 'Turn your hips around your spine rather than sliding laterally. Feel like you are rotating in a barrel.';
      case SwingError.lossOfPosture:
        return 'Maintain your spine angle from setup through impact. Use a mirror to check your posture.';
      case SwingError.liftingHead:
        return 'Keep your head still until after impact. Focus on a spot on the ground in front of the ball.';
      case SwingError.armCollapse:
        return 'Keep right arm wider on backswing. Feel tension in right tricep at the top.';
      case SwingError.overswing:
        return 'Shorten backswing to where club shaft is parallel to ground at the top. Use mirror feedback.';
      case SwingError.chickenwing:
        return 'Extend left arm through impact. Imagine a straight line from left shoulder to club head.';
    }
  }
}

// Main class for analyzing swings
class SwingAnalyzer {
  final PoseDetector _poseDetector = PoseDetector();
  final gyroDataEnabled = false; // Set to true when gyroscope data is available

  // Singleton instance
  static final SwingAnalyzer _instance = SwingAnalyzer._internal();

  factory SwingAnalyzer() {
    return _instance;
  }

  SwingAnalyzer._internal();

  // Initialize the analyzer
  Future<void> initialize() async {
    await _poseDetector.initialize();
  }

  // Main method to analyze a swing from video
  Future<SwingData> analyzeSwing({
    required File videoFile,
    required String selectedClubName,
    double? userHeightCm,
  }) async {
    try {
      // Get pose data from video
      final poseResults = await _poseDetector.detectPoseFromVideo(videoFile);

      // Find appropriate club
      final club = Club.availableClubs.firstWhere(
        (club) => club.name == selectedClubName,
        orElse: () => Club.driver, // Default to driver if not found
      );

      // Calculate swing metrics
      final swingSpeedMph = await _calculateSwingSpeed(poseResults, club);
      final ballSpeedMph = club.calculateBallSpeed(swingSpeedMph);
      final carryDistanceYards = club.calculateCarryDistance(swingSpeedMph);

      // Detect swing errors
      final detectedErrors = await _detectSwingErrors(poseResults);

      // Create and return SwingData object
      return SwingData(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        selectedClub: selectedClubName,
        swingSpeedMph: swingSpeedMph,
        ballSpeedMph: ballSpeedMph,
        carryDistanceYards: carryDistanceYards,
        detectedErrors: detectedErrors.map((error) => error.label).toList(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error analyzing swing: $e');
      }

      // Return placeholder data on error
      return SwingData(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        selectedClub: selectedClubName,
        swingSpeedMph: 85.0, // Default speed
        ballSpeedMph: 125.0, // Default ball speed
        carryDistanceYards: 220.0, // Default distance
        detectedErrors: ['Error analyzing swing'],
      );
    }
  }

  // Calculate swing speed from pose data
  Future<double> _calculateSwingSpeed(
      List<PoseDetectionResult> poseResults, Club club) async {
    // TODO: Implement actual swing speed calculation based on wrist movement and gyroscope data
    // This is placeholder logic based on wrist velocity

    // For now, use random value with realistic range for development
    final random = Random();
    double baseSpeed;

    // Realistic ranges based on club
    if (club.name.contains('Driver')) {
      baseSpeed = 85.0 + random.nextDouble() * 25.0; // 85-110 mph range
    } else if (club.name.contains('Wood')) {
      baseSpeed = 80.0 + random.nextDouble() * 20.0; // 80-100 mph range
    } else if (club.name.contains('Iron') &&
        int.tryParse(club.name[0]) != null &&
        int.parse(club.name[0]) < 5) {
      baseSpeed = 75.0 + random.nextDouble() * 20.0; // 75-95 mph range
    } else if (club.name.contains('Iron')) {
      baseSpeed = 70.0 + random.nextDouble() * 20.0; // 70-90 mph range
    } else {
      // Wedges
      baseSpeed = 65.0 + random.nextDouble() * 20.0; // 65-85 mph range
    }

    // When actual implementation is done, use:
    // 1. Track wrist keypoints through the swing
    // 2. Calculate maximum velocity during downswing
    // 3. Convert to mph using calibration factors

    return baseSpeed;
  }

  // Detect swing errors from pose data
  Future<List<SwingError>> _detectSwingErrors(
      List<PoseDetectionResult> poseResults) async {
    // TODO: Implement actual swing error detection using ML model
    // This is placeholder logic that returns random errors for development

    final random = Random();
    final List<SwingError> errors = [];

    // Randomly select 0-3 errors for development purposes
    final numErrors = random.nextInt(3);
    final allErrors = SwingError.values.toList()..shuffle(random);

    for (var i = 0; i < numErrors; i++) {
      errors.add(allErrors[i]);
    }

    // When actual implementation is done:
    // 1. Extract key features from pose data
    // 2. Run TensorFlow Lite model to classify swing errors
    // 3. Return detected errors with confidence scores

    return errors;
  }

  // Future method for when gyroscope data is available
  Future<double> _fuseGyroData(
      List<PoseDetectionResult> poseResults, List<double> gyroData) async {
    // TODO: Implement sensor fusion algorithm as described in the MVP blueprint
    // Combine wrist tracking speed with gyroscope data

    return 90.0; // Default placeholder value
  }
}
