class SwingUser {
  final String id;
  final String email;
  final String displayName;
  final double heightCm;
  final String? photoUrl;
  final String subscriptionTier; // 'free', 'pro', 'elite'
  final int dailyAnalysesUsed;
  final DateTime lastAnalysisDate;
  final int totalSwingsAnalyzed;

  SwingUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.heightCm,
    this.photoUrl,
    required this.subscriptionTier,
    required this.dailyAnalysesUsed,
    required this.lastAnalysisDate,
    required this.totalSwingsAnalyzed,
  });

  // Create a new user with default values
  factory SwingUser.create({
    required String id,
    required String email,
    String? displayName,
    double heightCm = 175.0, // Default height
  }) {
    return SwingUser(
      id: id,
      email: email,
      displayName: displayName ?? email.split('@').first,
      heightCm: heightCm,
      photoUrl: null,
      subscriptionTier: 'free',
      dailyAnalysesUsed: 0,
      lastAnalysisDate: DateTime.now(),
      totalSwingsAnalyzed: 0,
    );
  }

  // Create from Firestore document
  factory SwingUser.fromMap(Map<String, dynamic> data, String id) {
    return SwingUser(
      id: id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      heightCm: data['heightCm'] ?? 175.0,
      photoUrl: data['photoUrl'],
      subscriptionTier: data['subscriptionTier'] ?? 'free',
      dailyAnalysesUsed: data['dailyAnalysesUsed'] ?? 0,
      lastAnalysisDate:
          data['lastAnalysisDate'] != null
              ? DateTime.parse(data['lastAnalysisDate'])
              : DateTime.now(),
      totalSwingsAnalyzed: data['totalSwingsAnalyzed'] ?? 0,
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'heightCm': heightCm,
      'photoUrl': photoUrl,
      'subscriptionTier': subscriptionTier,
      'dailyAnalysesUsed': dailyAnalysesUsed,
      'lastAnalysisDate': lastAnalysisDate.toIso8601String(),
      'totalSwingsAnalyzed': totalSwingsAnalyzed,
    };
  }

  // Check if user can analyze more swings today
  bool canAnalyzeMoreSwings() {
    // Reset daily count if it's a new day
    if (lastAnalysisDate.day != DateTime.now().day ||
        lastAnalysisDate.month != DateTime.now().month ||
        lastAnalysisDate.year != DateTime.now().year) {
      return true;
    }

    switch (subscriptionTier) {
      case 'free':
        return dailyAnalysesUsed < 3; // 3 free analyses per day
      case 'pro':
      case 'elite':
        return true; // Unlimited for paid tiers
      default:
        return false;
    }
  }

  // Create a new instance with updated properties
  SwingUser copyWith({
    String? displayName,
    double? heightCm,
    String? photoUrl,
    String? subscriptionTier,
    int? dailyAnalysesUsed,
    DateTime? lastAnalysisDate,
    int? totalSwingsAnalyzed,
  }) {
    return SwingUser(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      heightCm: heightCm ?? this.heightCm,
      photoUrl: photoUrl ?? this.photoUrl,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      dailyAnalysesUsed: dailyAnalysesUsed ?? this.dailyAnalysesUsed,
      lastAnalysisDate: lastAnalysisDate ?? this.lastAnalysisDate,
      totalSwingsAnalyzed: totalSwingsAnalyzed ?? this.totalSwingsAnalyzed,
    );
  }
}
