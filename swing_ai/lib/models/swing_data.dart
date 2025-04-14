// Defines the data model for a single golf swing analysis.

// import 'package:cloud_firestore/cloud_firestore.dart'; // If using Timestamps
// import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'; // If storing Pose objects

class SwingData {
  final String id; // Unique identifier
  final DateTime timestamp;
  final String selectedClub;

  // Calculated Metrics
  final double? swingSpeedMph;
  final double? ballSpeedMph;
  final double? carryDistanceYards;

  // Error Detection (Could be enums or strings)
  final List<String> detectedErrors; // e.g., ['Over-the-top', 'Casting']

  // Raw Data (Optional - consider privacy/storage implications)
  // final String? videoPath; // Path to the recorded video file
  // final List<Pose>? poseKeypoints; // List of detected poses over time
  // final List<GyroDataPoint>? gyroData; // Gyroscope readings

  SwingData({
    required this.id,
    required this.timestamp,
    required this.selectedClub,
    this.swingSpeedMph,
    this.ballSpeedMph,
    this.carryDistanceYards,
    this.detectedErrors = const [],
    // this.videoPath,
    // this.poseKeypoints,
    // this.gyroData,
  });

  // Add methods for JSON serialization/deserialization if needed for Firebase
  // Map<String, dynamic> toJson() => {
  //   'id': id,
  //   'timestamp': Timestamp.fromDate(timestamp),
  //   'selectedClub': selectedClub,
  //   'swingSpeedMph': swingSpeedMph,
  //   'ballSpeedMph': ballSpeedMph,
  //   'carryDistanceYards': carryDistanceYards,
  //   'detectedErrors': detectedErrors,
  // };

  // factory SwingData.fromJson(Map<String, dynamic> json) => SwingData(
  //   id: json['id'] as String,
  //   timestamp: (json['timestamp'] as Timestamp).toDate(),
  //   selectedClub: json['selectedClub'] as String,
  //   swingSpeedMph: json['swingSpeedMph'] as double?,
  //   ballSpeedMph: json['ballSpeedMph'] as double?,
  //   carryDistanceYards: json['carryDistanceYards'] as double?,
  //   detectedErrors: List<String>.from(json['detectedErrors'] ?? []),
  // );
}

// Placeholder for sensor data point if storing raw sensor data
// class GyroDataPoint {
//   final double x, y, z;
//   final Duration timestampOffset;
// }
