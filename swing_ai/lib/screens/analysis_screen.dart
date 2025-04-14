import 'package:flutter/material.dart';
import 'package:swing_ai/models/swing_data.dart'; // Import SwingData
import 'package:swing_ai/widgets/error_indicator.dart'; // Import ErrorIndicator
import 'package:swing_ai/widgets/metrics_display.dart'; // Import MetricsDisplay

class AnalysisScreen extends StatelessWidget {
  final SwingData swingData; // Accept analysis results

  const AnalysisScreen({super.key, required this.swingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis: ${swingData.selectedClub}'),
        leading: IconButton(
          // Add back button
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Display Metrics using MetricsDisplay widget
            MetricsDisplay(
              label: 'Swing Speed',
              value:
                  '${swingData.swingSpeedMph?.toStringAsFixed(1) ?? "--"} mph',
              icon: Icons.speed, // Example icon
            ),
            MetricsDisplay(
              label: 'Est. Ball Speed',
              value:
                  '${swingData.ballSpeedMph?.toStringAsFixed(1) ?? "--"} mph',
              icon: Icons.shutter_speed, // Example icon
            ),
            MetricsDisplay(
              label: 'Est. Carry Distance',
              value:
                  '${swingData.carryDistanceYards?.toStringAsFixed(0) ?? "--"} yds',
              icon: Icons.straighten, // Example icon
            ),
            const SizedBox(height: 24),

            // Display Errors using ErrorIndicator widget
            ErrorIndicator(errors: swingData.detectedErrors),

            const SizedBox(height: 40),
            // TODO: Add buttons for saving, sharing, or recording new swing
            ElevatedButton.icon(
                icon: const Icon(Icons.save_alt),
                label: const Text('Save Analysis (Not Implemented)'),
                onPressed: () {
                  // TODO: Implement save to Firebase
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Save functionality not implemented yet.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                )),
            const SizedBox(height: 16),
            OutlinedButton.icon(
                icon: const Icon(Icons.videocam),
                label: const Text('Record New Swing'),
                onPressed: () {
                  Navigator.of(context).pop(); // Go back to recording screen
                },
                style: OutlinedButton.styleFrom(
                  side:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                )),
          ],
        ),
      ),
    );
  }
}
