import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:swing_ai/models/swing_data.dart';

class SwingHistoryItem extends StatelessWidget {
  final SwingData swing;
  final VoidCallback? onTap;

  const SwingHistoryItem({super.key, required this.swing, this.onTap});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMM d, yyyy - hh:mm a');

    return Card(
      elevation: 1.0,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(
            _getClubIcon(swing.selectedClub), // Helper to get club icon
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          swing.selectedClub,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateFormat.format(swing.timestamp)),
            const SizedBox(height: 4),
            Text(
              'Speed: ${swing.swingSpeedMph?.toStringAsFixed(1) ?? "--"} mph | Dist: ${swing.carryDistanceYards?.toStringAsFixed(0) ?? "--"} yds',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
        trailing: swing.detectedErrors.isNotEmpty
            ? Icon(Icons.warning_amber_rounded, color: Colors.orange[700])
            : null,
        onTap: onTap,
        isThreeLine: true,
      ),
    );
  }

  // Helper function to map club names to icons (example)
  IconData _getClubIcon(String clubName) {
    switch (clubName.toLowerCase()) {
      case 'driver':
        return Icons
            .sports_golf; // Replace with a better driver icon if available
      case '7 iron':
        return Icons.sports_golf; // Replace with a better iron icon
      case 'pw':
        return Icons.sports_golf; // Replace with a better wedge icon
      default:
        return Icons.golf_course;
    }
  }
}
