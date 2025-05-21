import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swing_ai/providers/club_selection_provider.dart';
import 'package:swing_ai/models/golf_club.dart';
import 'package:swing_ai/screens/club_selection_screen.dart';

// The ClubSelector widget displays the currently selected club
// and allows the user to select a different club from their bag
class ClubSelector extends StatelessWidget {
  final String? selectedClubId;
  final Function(GolfClub)? onClubSelected;

  const ClubSelector({
    super.key,
    this.selectedClubId,
    this.onClubSelected,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClubSelectionProvider>(context);

    // Get the selected clubs from the provider
    final List<GolfClub> selectedClubs = provider.selectedClubs;

    // If no clubs are selected, show a button to set up clubs
    if (selectedClubs.isEmpty) {
      return _buildSetupButton(context);
    }

    // Get current club or default to first selected club
    GolfClub currentClub;
    if (selectedClubId != null) {
      // Find selected club by ID
      try {
        currentClub = selectedClubs.firstWhere(
          (club) => club.id == selectedClubId,
        );
      } catch (_) {
        // If not found, default to first club
        currentClub = selectedClubs.first;
      }
    } else {
      // Default to first club
      currentClub = selectedClubs.first;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentClub.id,
          icon: const Icon(Icons.arrow_downward, color: Colors.white),
          dropdownColor: Colors.black.withOpacity(0.7),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          onChanged: (String? newValue) {
            if (newValue != null) {
              try {
                final selectedClub = selectedClubs.firstWhere(
                  (club) => club.id == newValue,
                );

                // Call onClubSelected callback if provided
                if (onClubSelected != null) {
                  onClubSelected!(selectedClub);
                }
              } catch (_) {
                // If the club isn't found, we don't need to do anything
              }
            }
          },
          items: selectedClubs.map<DropdownMenuItem<String>>((GolfClub club) {
            return DropdownMenuItem<String>(
              value: club.id,
              child: Text('${club.type} (${club.loft}°)'),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Build a button to navigate to the club selection screen
  Widget _buildSetupButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ClubSelectionScreen()),
        );
      },
      icon: const Icon(Icons.golf_course),
      label: const Text('Set Up Your Clubs'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.5),
        foregroundColor: Colors.white,
      ),
    );
  }
}
