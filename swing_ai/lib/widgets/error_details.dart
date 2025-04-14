import 'package:flutter/material.dart';
import '../models/swing_analysis.dart';

class ErrorDetails extends StatelessWidget {
  final List<SwingError> errors;
  final Map<String, double> errorConfidence;

  const ErrorDetails({
    super.key,
    required this.errors,
    required this.errorConfidence,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final error in errors)
          if (error != SwingError.none) _buildErrorItem(error),
      ],
    );
  }

  Widget _buildErrorItem(SwingError error) {
    // Get error key and confidence value
    String errorKey = error.toString().split('.').last;
    double confidence = errorConfidence[errorKey] ?? 0.0;

    // Error details
    String title = '';
    String description = '';
    IconData icon = Icons.error_outline;

    switch (error) {
      case SwingError.overTheTop:
        title = 'Over-the-Top Swing Path';
        description =
            'Your club is moving from outside to inside during the downswing, causing a slice or pull.';
        icon = Icons.undo;
        break;
      case SwingError.earlyExtension:
        title = 'Early Extension';
        description =
            'You\'re standing up or thrusting your hips toward the ball during the downswing.';
        icon = Icons.height;
        break;
      case SwingError.casting:
        title = 'Casting';
        description =
            'You\'re releasing the club angle too early in the downswing, losing power and accuracy.';
        icon = Icons.back_hand;
        break;
      case SwingError.none:
        return const SizedBox.shrink();
    }

    // Calculate severity based on confidence
    String severity = '';
    Color severityColor = Colors.green;

    if (confidence >= 0.8) {
      severity = 'Major Issue';
      severityColor = Colors.red;
    } else if (confidence >= 0.5) {
      severity = 'Moderate Issue';
      severityColor = Colors.orange;
    } else {
      severity = 'Minor Issue';
      severityColor = Colors.amber;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: severityColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor.withValues(alpha: 51),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    severity,
                    style: TextStyle(
                      color: severityColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: confidence,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(severityColor),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Confidence: ${(confidence * 100).toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
