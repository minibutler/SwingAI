import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  final List<String> errors;

  const ErrorIndicator({super.key, required this.errors});

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty) {
      return const SizedBox.shrink(); // Return empty space if no errors
    }

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      color: Colors.orange[50], // Light orange background for warning
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.orange[800], size: 24),
                const SizedBox(width: 8),
                Text(
                  'Potential Errors Detected:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...errors
                .map((error) => Padding(
                    padding: const EdgeInsets.only(
                        left: 32.0, top: 4.0), // Indent error text
                    child: Text(
                      '• $error', // Bullet point
                      style: TextStyle(fontSize: 14, color: Colors.orange[800]),
                    )))
                .toList(),
          ],
        ),
      ),
    );
  }
}
