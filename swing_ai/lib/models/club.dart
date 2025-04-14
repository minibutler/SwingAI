class Club {
  final String id;
  final String name;
  final double smashFactor;
  final double distanceMultiplier;
  final double heightRatio;

  const Club({
    required this.id,
    required this.name,
    required this.smashFactor,
    required this.distanceMultiplier,
    required this.heightRatio,
  });

  // Pre-defined common clubs
  static const Club driver = Club(
    id: 'driver',
    name: 'Driver',
    smashFactor: 1.48,
    distanceMultiplier: 2.3,
    heightRatio: 0.85,
  );

  static const Club iron7 = Club(
    id: 'iron7',
    name: '7 Iron',
    smashFactor: 1.33,
    distanceMultiplier: 1.8,
    heightRatio: 0.77,
  );

  static const Club pitchingWedge = Club(
    id: 'pw',
    name: 'Pitching Wedge',
    smashFactor: 1.25,
    distanceMultiplier: 1.3,
    heightRatio: 0.75,
  );

  // List of available clubs
  static const List<Club> availableClubs = [driver, iron7, pitchingWedge];

  // Method to calculate club length based on user height
  double calculateLength(double userHeightCm) {
    return userHeightCm * heightRatio / 100; // Convert to meters
  }

  // Method to calculate ball speed based on swing speed
  double calculateBallSpeed(double swingSpeedMph) {
    return swingSpeedMph * smashFactor;
  }

  // Method to calculate carry distance based on swing speed
  double calculateCarryDistance(double swingSpeedMph) {
    return swingSpeedMph * distanceMultiplier;
  }

  @override
  String toString() => name;
}
