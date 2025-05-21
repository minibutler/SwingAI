import 'package:swing_ai/models/golf_club.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserClubs {
  String? selectedSetId;
  List<String> selectedClubIds = [];

  UserClubs({
    this.selectedSetId,
    this.selectedClubIds = const [],
  });

  // Convert to a map for saving to SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'selectedSetId': selectedSetId,
      'selectedClubIds': selectedClubIds,
    };
  }

  // Create from a map (loaded from SharedPreferences)
  factory UserClubs.fromJson(Map<String, dynamic> json) {
    return UserClubs(
      selectedSetId: json['selectedSetId'],
      selectedClubIds: List<String>.from(json['selectedClubIds'] ?? []),
    );
  }

  // Get all selected clubs as GolfClub objects
  List<GolfClub> get selectedClubs {
    if (selectedSetId == null) return [];

    final clubSet = ClubSets.getById(selectedSetId!);
    if (clubSet == null) return [];

    return clubSet.clubs
        .where((club) => selectedClubIds.contains(club.id))
        .toList();
  }

  // Check if a club is selected
  bool isClubSelected(String clubId) {
    return selectedClubIds.contains(clubId);
  }

  // Toggle selection of a club
  void toggleClub(String clubId) {
    if (isClubSelected(clubId)) {
      selectedClubIds.remove(clubId);
    } else {
      selectedClubIds.add(clubId);
    }
  }

  // Set the selected club set
  void setClubSet(String setId) {
    // If changing to a different set, clear the selected clubs
    if (selectedSetId != setId) {
      selectedClubIds = [];
    }
    selectedSetId = setId;
  }
}

// Helper class to save and load user club preferences
class UserClubsStorage {
  static const String _storageKey = 'user_clubs';

  // Save user club preferences
  static Future<bool> saveUserClubs(UserClubs userClubs) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String json = jsonEncode(userClubs.toJson());
      return await prefs.setString(_storageKey, json);
    } catch (e) {
      print('Error saving user clubs: $e');
      return false;
    }
  }

  // Load user club preferences
  static Future<UserClubs> loadUserClubs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? json = prefs.getString(_storageKey);

      if (json == null) {
        return UserClubs();
      }

      final Map<String, dynamic> data = jsonDecode(json);
      return UserClubs.fromJson(data);
    } catch (e) {
      print('Error loading user clubs: $e');
      return UserClubs();
    }
  }
}
