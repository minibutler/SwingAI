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

  static const Club threeWood = Club(
    id: 'three_wood',
    name: '3 Wood',
    smashFactor: 1.46,
    distanceMultiplier: 2.1,
    heightRatio: 0.83,
  );

  static const Club fiveWood = Club(
    id: 'five_wood',
    name: '5 Wood',
    smashFactor: 1.44,
    distanceMultiplier: 2.0,
    heightRatio: 0.82,
  );

  static const Club hybrid = Club(
    id: 'hybrid',
    name: 'Hybrid',
    smashFactor: 1.42,
    distanceMultiplier: 1.95,
    heightRatio: 0.81,
  );

  static const Club iron3 = Club(
    id: 'iron3',
    name: '3 Iron',
    smashFactor: 1.40,
    distanceMultiplier: 1.93,
    heightRatio: 0.80,
  );

  static const Club iron4 = Club(
    id: 'iron4',
    name: '4 Iron',
    smashFactor: 1.38,
    distanceMultiplier: 1.90,
    heightRatio: 0.79,
  );

  static const Club iron5 = Club(
    id: 'iron5',
    name: '5 Iron',
    smashFactor: 1.36,
    distanceMultiplier: 1.87,
    heightRatio: 0.78,
  );

  static const Club iron6 = Club(
    id: 'iron6',
    name: '6 Iron',
    smashFactor: 1.34,
    distanceMultiplier: 1.83,
    heightRatio: 0.78,
  );

  static const Club iron7 = Club(
    id: 'iron7',
    name: '7 Iron',
    smashFactor: 1.33,
    distanceMultiplier: 1.8,
    heightRatio: 0.77,
  );

  static const Club iron8 = Club(
    id: 'iron8',
    name: '8 Iron',
    smashFactor: 1.31,
    distanceMultiplier: 1.7,
    heightRatio: 0.76,
  );

  static const Club iron9 = Club(
    id: 'iron9',
    name: '9 Iron',
    smashFactor: 1.29,
    distanceMultiplier: 1.6,
    heightRatio: 0.76,
  );

  static const Club pitchingWedge = Club(
    id: 'pw',
    name: 'Pitching Wedge',
    smashFactor: 1.25,
    distanceMultiplier: 1.3,
    heightRatio: 0.75,
  );

  static const Club gapWedge = Club(
    id: 'gw',
    name: 'Gap Wedge',
    smashFactor: 1.22,
    distanceMultiplier: 1.2,
    heightRatio: 0.74,
  );

  static const Club sandWedge = Club(
    id: 'sw',
    name: 'Sand Wedge',
    smashFactor: 1.20,
    distanceMultiplier: 1.0,
    heightRatio: 0.73,
  );

  static const Club lobWedge = Club(
    id: 'lw',
    name: 'Lob Wedge',
    smashFactor: 1.18,
    distanceMultiplier: 0.9,
    heightRatio: 0.72,
  );

  // List of available clubs
  static const List<Club> availableClubs = [
    driver,
    threeWood,
    fiveWood,
    hybrid,
    iron3,
    iron4,
    iron5,
    iron6,
    iron7,
    iron8,
    iron9,
    pitchingWedge,
    gapWedge,
    sandWedge,
    lobWedge
  ];

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
