import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';

import '../models/swing_analysis.dart';
import '../widgets/metric_card.dart';
import '../widgets/error_details.dart';

class SwingAnalysisResultScreen extends StatefulWidget {
  final SwingAnalysis analysis;

  const SwingAnalysisResultScreen({super.key, required this.analysis});

  @override
  State<SwingAnalysisResultScreen> createState() =>
      _SwingAnalysisResultScreenState();
}

class _SwingAnalysisResultScreenState extends State<SwingAnalysisResultScreen> {
  late VideoPlayerController _videoController;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  // Initialize the video player
  Future<void> _initializeVideoPlayer() async {
    // Check if video is local or from Firebase Storage
    if (widget.analysis.videoUrl.startsWith('http')) {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.analysis.videoUrl),
      );
    } else {
      _videoController = VideoPlayerController.file(
        File(widget.analysis.videoUrl),
      );
    }

    await _videoController.initialize();
    await _videoController.setLooping(true);

    if (mounted) {
      setState(() {
        _videoInitialized = true;
      });
    }
  }

  // Play/pause the video
  void _togglePlayback() {
    _videoController.value.isPlaying
        ? _videoController.pause()
        : _videoController.play();
  }

  // Share results
  void _shareResults() {
    final String result = 'My SwingAI analysis results:\n'
        'Club: ${widget.analysis.club.name}\n'
        'Swing speed: ${widget.analysis.swingSpeedMph} mph\n'
        'Ball speed: ${widget.analysis.ballSpeedMph} mph\n'
        'Carry distance: ${widget.analysis.carryDistanceYards} yards\n'
        'Accuracy: ${widget.analysis.accuracy.toStringAsFixed(1)}%';

    Share.share(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swing Analysis'),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: _shareResults),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video player
            _videoInitialized
                ? GestureDetector(
                    onTap: _togglePlayback,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        ),
                        if (!_videoController.value.isPlaying)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                      ],
                    ),
                  )
                : const AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Center(child: CircularProgressIndicator()),
                  ),

            // Analysis overview
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.analysis.club.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Accuracy: ${widget.analysis.accuracy.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _getAccuracyColor(widget.analysis.accuracy),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Analyzed on ${widget.analysis.timestamp.day}/${widget.analysis.timestamp.month}/${widget.analysis.timestamp.year}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Metrics cards
                  Row(
                    children: [
                      Expanded(
                        child: MetricCard(
                          title: 'Swing Speed',
                          value: '${widget.analysis.swingSpeedMph}',
                          unit: 'mph',
                          icon: Icons.speed,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: MetricCard(
                          title: 'Ball Speed',
                          value: '${widget.analysis.ballSpeedMph}',
                          unit: 'mph',
                          icon: Icons.sports_baseball,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  MetricCard(
                    title: 'Carry Distance',
                    value: '${widget.analysis.carryDistanceYards}',
                    unit: 'yards',
                    icon: Icons.golf_course,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 24),

                  // Swing errors section
                  const Text(
                    'Swing Analysis',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.analysis.getErrorsDescription(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // Error details
                  if (widget.analysis.detectedErrors.isNotEmpty &&
                      !widget.analysis.detectedErrors.contains(SwingError.none))
                    ErrorDetails(
                      errors: widget.analysis.detectedErrors,
                      errorConfidence: widget.analysis.errorConfidence,
                    ),

                  const SizedBox(height: 24),

                  // Chart section title
                  const Text(
                    'Performance Metrics',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Radar chart for metrics
                  SizedBox(height: 250, child: _buildRadarChart()),

                  const SizedBox(height: 24),

                  // Tips section
                  const Text(
                    'Pro Tips',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildTips(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build radar chart for visualizing metrics
  Widget _buildRadarChart() {
    return RadarChart(
      RadarChartData(
        radarShape: RadarShape.circle,
        dataSets: [
          RadarDataSet(
            fillColor: Colors.blue.withValues(alpha: 51),
            borderColor: Colors.blue,
            entryRadius: 2,
            dataEntries: [
              RadarEntry(
                value: widget.analysis.swingSpeedMph / 120 * 10,
              ), // Max speed ~120mph
              RadarEntry(value: widget.analysis.accuracy / 10), // 0-10 scale
              RadarEntry(
                value: widget.analysis.ballSpeedMph / 180 * 10,
              ), // Max ball speed ~180mph
              RadarEntry(
                value: widget.analysis.carryDistanceYards / 300 * 10,
              ), // Max distance ~300 yards
              RadarEntry(
                value: 10 - _getErrorCount() * 2.5,
              ), // 10 if no errors, decreases by 2.5 per error
            ],
          ),
        ],
        tickCount: 5,
        ticksTextStyle: const TextStyle(color: Colors.black, fontSize: 10),
        radarBorderData: const BorderSide(color: Colors.grey),
        gridBorderData: const BorderSide(color: Colors.grey, width: 0.5),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 12),
        titlePositionPercentageOffset: 0.1,
        getTitle: (index, angle) {
          switch (index) {
            case 0:
              return RadarChartTitle(text: 'Swing Speed', angle: angle);
            case 1:
              return RadarChartTitle(text: 'Accuracy', angle: angle);
            case 2:
              return RadarChartTitle(text: 'Ball Speed', angle: angle);
            case 3:
              return RadarChartTitle(text: 'Distance', angle: angle);
            case 4:
              return RadarChartTitle(text: 'Form', angle: angle);
            default:
              return RadarChartTitle(text: '', angle: angle);
          }
        },
      ),
      duration: const Duration(milliseconds: 400),
    );
  }

  // Build tips based on detected errors
  Widget _buildTips() {
    List<Widget> tips = [];

    if (widget.analysis.detectedErrors.contains(SwingError.overTheTop)) {
      tips.add(
        _buildTipCard(
          'Fix Over-the-Top Swing',
          'Practice an inside-out swing path. Focus on dropping your hands and arms down before starting the downswing.',
          Icons.sports_golf,
        ),
      );
    }

    if (widget.analysis.detectedErrors.contains(SwingError.earlyExtension)) {
      tips.add(
        _buildTipCard(
          'Fix Early Extension',
          'Maintain your spine angle throughout the swing. Practice with a chair behind you to prevent standing up too early.',
          Icons.height,
        ),
      );
    }

    if (widget.analysis.detectedErrors.contains(SwingError.casting)) {
      tips.add(
        _buildTipCard(
          'Fix Casting',
          'Maintain wrist hinge longer during downswing. Practice the feeling of "lag" by keeping your hands ahead of the clubhead.',
          Icons.back_hand,
        ),
      );
    }

    if (tips.isEmpty) {
      tips.add(
        _buildTipCard(
          'Great Swing!',
          'Your swing looks good. Focus on consistency and repeatability in your swing tempo.',
          Icons.thumb_up,
        ),
      );
    }

    return Column(children: tips);
  }

  // Build individual tip card
  Widget _buildTipCard(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get accuracy color based on score
  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) {
      return Colors.green;
    } else if (accuracy >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // Count the number of errors
  int _getErrorCount() {
    // If it contains "none", there are no errors
    if (widget.analysis.detectedErrors.contains(SwingError.none)) {
      return 0;
    }
    return widget.analysis.detectedErrors.length;
  }
}
