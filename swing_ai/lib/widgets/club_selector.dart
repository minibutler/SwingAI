import 'package:flutter/material.dart';
import '../models/club.dart';

class ClubSelector extends StatelessWidget {
  final Club selectedClub;
  final Function(Club) onClubSelected;

  const ClubSelector({
    super.key,
    required this.selectedClub,
    required this.onClubSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Club:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                Club.availableClubs.map((club) {
                  final isSelected = club.id == selectedClub.id;
                  return _buildClubOption(club, isSelected);
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildClubOption(Club club, bool isSelected) {
    return GestureDetector(
      onTap: () => onClubSelected(club),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.white30,
            width: 1.0,
          ),
        ),
        child: Text(
          club.name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
