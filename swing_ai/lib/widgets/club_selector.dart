import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider

// Simple state management for selected club
class ClubSelectionState extends ChangeNotifier {
  String _selectedClub = '7 Iron'; // Default club
  final List<String> _availableClubs = ['Driver', '7 Iron', 'PW'];

  String get selectedClub => _selectedClub;
  List<String> get availableClubs => _availableClubs;

  void selectClub(String club) {
    if (_availableClubs.contains(club)) {
      _selectedClub = club;
      notifyListeners();
    }
  }
}

class ClubSelector extends StatelessWidget {
  final String? selectedClub;
  final Function(String)? onClubSelected;

  const ClubSelector({
    super.key,
    this.selectedClub,
    this.onClubSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Access the state using Provider
    final clubState = Provider.of<ClubSelectionState>(context);

    // Use selectedClub from props if provided, otherwise from Provider
    final currentClub = selectedClub ?? clubState.selectedClub;
    final clubs = clubState.availableClubs;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentClub,
          icon: const Icon(Icons.arrow_downward, color: Colors.white),
          dropdownColor: Colors.black.withOpacity(0.7),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          onChanged: (String? newValue) {
            if (newValue != null) {
              // Call onClubSelected callback if provided
              if (onClubSelected != null) {
                onClubSelected!(newValue);
              }
              // Update the provider state if no callback is provided
              else {
                Provider.of<ClubSelectionState>(context, listen: false)
                    .selectClub(newValue);
              }
            }
          },
          items: clubs.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
