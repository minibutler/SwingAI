import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/club.dart';
import '../models/swing_analysis.dart';

class AnalyzingScreen extends StatefulWidget {
  final String videoPath;
  final Club club;

  const AnalyzingScreen({
    super.key,
    required this.videoPath,
    required this.club,
  });

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> {
  // For MVP, we'll simulate analysis with a timer
  late Timer _analysisTimer;
  int _progress = 0;
  final int _totalSteps = 5;
  final List<String> _analysisSteps = [
    'Processing video...',
    'Detecting key points...',
    'Calculating swing speed...',
    'Analyzing swing mechanics...',
    'Generating recommendations...',
  ];

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  @override
  void dispose() {
    _analysisTimer.cancel();
    super.dispose();
  }

  // Start the analysis process
  void _startAnalysis() {
    // Start a timer to update progress
    _analysisTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_progress < _totalSteps) {
          _progress++;
        } else {
          timer.cancel();
          _onAnalysisComplete();
        }
      });
    });
  }

  // Handle completion of analysis
  void _onAnalysisComplete() {
    // In a real app, this would come from the SwingAnalyzerService
    // Create a sample analysis result
    final analysis = SwingAnalysis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      userId: 'user123',
      videoUrl: widget.videoPath,
      club: widget.club,
      swingSpeedMph: 95.5,
      ballSpeedMph: widget.club.calculateBallSpeed(95.5),
      carryDistanceYards: widget.club.calculateCarryDistance(95.5),
      detectedErrors: [SwingError.earlyExtension],
      errorConfidence: {
        'overTheTop': 0.2,
        'earlyExtension': 0.7,
        'casting': 0.3,
      },
      accuracy: 78.5,
    );

    // Navigate to the results screen
    Navigator.of(context).pushReplacementNamed('/results', arguments: analysis);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyzing Swing'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animation
              SizedBox(
                height: 200,
                child: Lottie.network(
                  'https://assets5.lottiefiles.com/packages/lf20_jyxjvfz6.json',
                  repeat: true,
                ),
              ),
              const SizedBox(height: 32),

              // Progress text
              Text(
                _progress < _totalSteps
                    ? _analysisSteps[_progress]
                    : 'Analysis complete!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Progress bar
              ClipRounded(
                child: LinearProgressIndicator(
                  value: _progress / _totalSteps,
                  minHeight: 10,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Progress counter
              Text(
                'Step $_progress of $_totalSteps',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 48),

              // Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Please wait while we analyze your swing',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'re using AI to detect your swing speed, ball speed, and potential errors',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Cancel button
              TextButton(
                onPressed: () {
                  _analysisTimer.cancel();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel Analysis'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper widget for rounded clip
class ClipRounded extends StatelessWidget {
  final Widget child;
  final double borderRadius;

  const ClipRounded({super.key, required this.child, this.borderRadius = 8.0});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: child,
    );
  }
}
