import 'package:cloud_firestore/cloud_firestore.dart';
import 'club.dart';

enum SwingError { none, overTheTop, earlyExtension, casting }

class SwingAnalysis {
  final String id;
  final DateTime timestamp;
  final String userId;
  final String videoUrl;
  final Club club;
  final double swingSpeedMph;
  final double ballSpeedMph;
  final double carryDistanceYards;
  final List<SwingError> detectedErrors;
  final Map<String, double> errorConfidence;
  final double accuracy; // 0-100 scale

  SwingAnalysis({
    required this.id,
    required this.timestamp,
    required this.userId,
    required this.videoUrl,
    required this.club,
    required this.swingSpeedMph,
    required this.ballSpeedMph,
    required this.carryDistanceYards,
    required this.detectedErrors,
    required this.errorConfidence,
    required this.accuracy,
  });

  // Create from Firestore document
  factory SwingAnalysis.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return SwingAnalysis(
      id: doc.id,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      userId: data['userId'],
      videoUrl: data['videoUrl'],
      club: Club.availableClubs.firstWhere(
        (club) => club.id == data['clubId'],
        orElse: () => Club.driver,
      ),
      swingSpeedMph: data['swingSpeedMph'],
      ballSpeedMph: data['ballSpeedMph'],
      carryDistanceYards: data['carryDistanceYards'],
      detectedErrors: List<SwingError>.from(
        (data['detectedErrors'] as List).map(
          (e) => SwingError.values.firstWhere(
            (error) => error.toString() == e,
            orElse: () => SwingError.none,
          ),
        ),
      ),
      errorConfidence: Map<String, double>.from(data['errorConfidence'] ?? {}),
      accuracy: data['accuracy'] ?? 0.0,
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'timestamp': timestamp,
      'userId': userId,
      'videoUrl': videoUrl,
      'clubId': club.id,
      'swingSpeedMph': swingSpeedMph,
      'ballSpeedMph': ballSpeedMph,
      'carryDistanceYards': carryDistanceYards,
      'detectedErrors': detectedErrors.map((e) => e.toString()).toList(),
      'errorConfidence': errorConfidence,
      'accuracy': accuracy,
    };
  }

  // Get description of detected errors
  String getErrorsDescription() {
    if (detectedErrors.isEmpty ||
        detectedErrors.contains(SwingError.none) &&
            detectedErrors.length == 1) {
      return "No major swing errors detected";
    }

    final List<String> errorDescriptions = [];

    if (detectedErrors.contains(SwingError.overTheTop)) {
      errorDescriptions.add("Over-the-top swing path");
    }

    if (detectedErrors.contains(SwingError.earlyExtension)) {
      errorDescriptions.add("Early extension");
    }

    if (detectedErrors.contains(SwingError.casting)) {
      errorDescriptions.add("Casting or club release too early");
    }

    return errorDescriptions.join(", ");
  }
}
