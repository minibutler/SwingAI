import 'package:flutter/foundation.dart';
import 'package:swing_ai/models/golf_club.dart';
import 'package:swing_ai/models/user_clubs.dart';

class ClubSelectionProvider with ChangeNotifier {
  UserClubs _userClubs = UserClubs();
  bool _isLoading = true;

  ClubSelectionProvider() {
    _loadUserClubs();
  }

  // Getters
  UserClubs get userClubs => _userClubs;
  bool get isLoading => _isLoading;
  String? get selectedSetId => _userClubs.selectedSetId;
  List<String> get selectedClubIds => _userClubs.selectedClubIds;
  List<GolfClub> get selectedClubs => _userClubs.selectedClubs;

  // Get all available club sets
  List<ClubSet> get allClubSets => ClubSets.allSets;

  // Get club sets filtered by year
  List<ClubSet> getClubSetsByYear(int year) => ClubSets.getByYear(year);

  // Get club sets filtered by brand
  List<ClubSet> getClubSetsByBrand(String brand) => ClubSets.getByBrand(brand);

  // Get the currently selected club set
  ClubSet? get selectedSet =>
      selectedSetId != null ? ClubSets.getById(selectedSetId!) : null;

  // Check if a club is selected
  bool isClubSelected(String clubId) => _userClubs.isClubSelected(clubId);

  // Load user clubs from storage
  Future<void> _loadUserClubs() async {
    _isLoading = true;
    notifyListeners();

    _userClubs = await UserClubsStorage.loadUserClubs();

    _isLoading = false;
    notifyListeners();
  }

  // Save user clubs to storage
  Future<void> _saveUserClubs() async {
    await UserClubsStorage.saveUserClubs(_userClubs);
    notifyListeners();
  }

  // Select a club set
  void selectClubSet(String setId) {
    _userClubs.setClubSet(setId);
    _saveUserClubs();
  }

  // Toggle selection of a club
  void toggleClub(String clubId) {
    _userClubs.toggleClub(clubId);
    _saveUserClubs();
  }

  // Select multiple clubs at once
  void selectClubs(List<String> clubIds) {
    _userClubs.selectedClubIds = List.from(clubIds);
    _saveUserClubs();
  }

  // Clear all selected clubs
  void clearSelectedClubs() {
    _userClubs.selectedClubIds = [];
    _saveUserClubs();
  }
}
