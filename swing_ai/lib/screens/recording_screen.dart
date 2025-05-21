import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart'; // Requires camera dependency
// import 'package:permission_handler/permission_handler.dart'; // For requesting permissions
// import '../services/services.dart'; // For ML/Sensor interaction
import 'package:swing_ai/screens/analysis_screen.dart'; // For navigation
import 'package:swing_ai/widgets/club_selector.dart'; // Import ClubSelector
import 'package:swing_ai/models/swing_data.dart'; // Import SwingData for dummy data
import 'package:swing_ai/providers/club_selection_provider.dart'; // Import new provider
import 'package:swing_ai/models/golf_club.dart'; // Import GolfClub model

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  GolfClub? _selectedClub;
  // TODO: Add state for sensor data

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    // TODO: Request camera permissions
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        final firstCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras!.first,
        );

        _cameraController = CameraController(
          firstCamera,
          ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.yuv420,
        );

        await _cameraController!.initialize();
        if (!mounted) return;
        setState(() {
          _isCameraInitialized = true;
        });
      } else {
        print('No cameras available');
        // TODO: Show error message
      }
    } catch (e) {
      print('Error initializing camera: $e');
      // TODO: Show error message
    }
  }

  Future<void> _startRecording() async {
    if (!_isCameraInitialized ||
        _cameraController == null ||
        _cameraController!.value.isRecordingVideo) {
      return;
    }
    // TODO: Start sensor data collection
    try {
      await _cameraController!.startVideoRecording();
      if (!mounted) return;
      setState(() {
        _isRecording = true;
      });
      print('Recording started...');
      // Simulate 5-second recording then stop
      await Future.delayed(const Duration(seconds: 5));
      if (_isRecording) {
        // Check if still recording before stopping
        _stopRecording();
      }
    } catch (e) {
      print('Error starting/during recording: $e');
      if (!mounted) return;
      setState(() {
        _isRecording = false;
      });
      // TODO: Stop sensor data collection on error
    }
  }

  Future<void> _stopRecording() async {
    if (!_isCameraInitialized ||
        _cameraController == null ||
        !_cameraController!.value.isRecordingVideo) {
      return;
    }
    try {
      final videoFile = await _cameraController!.stopVideoRecording();
      if (!mounted) return;
      setState(() {
        _isRecording = false;
      });
      // TODO: Stop sensor data collection
      print('Recording stopped. Video saved to: ${videoFile.path}');

      // --- Placeholder Analysis & Navigation ---
      // Get the selected club from the provider
      final provider =
          Provider.of<ClubSelectionProvider>(context, listen: false);
      final selectedClubs = provider.selectedClubs;

      // Use the first selected club or a default value if none selected
      final clubToUse = _selectedClub ??
          (selectedClubs.isNotEmpty ? selectedClubs.first : null);

      final clubName = clubToUse != null ? clubToUse.type : "7 Iron";

      // Create dummy analysis results
      final dummyResult = SwingData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          selectedClub: clubName,
          swingSpeedMph: 95.5 + (clubName == 'Driver' ? 10 : 0),
          ballSpeedMph: 135.2 + (clubName == 'Driver' ? 15 : 0),
          carryDistanceYards: 160 + (clubName == 'Driver' ? 80 : 0),
          detectedErrors:
              clubName == 'PW' ? [] : ['Over-the-top'] // Example error
          );

      // Navigate to Analysis Screen with results
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisScreen(swingData: dummyResult),
        ),
      );
      // -----------------------------------------
    } catch (e) {
      print('Error stopping recording: $e');
      // Ensure recording state is reset even if stopping fails
      if (mounted && _cameraController!.value.isRecordingVideo) {
        setState(() {
          _isRecording = false;
        });
      }
    }
  }

  void _onClubSelected(GolfClub club) {
    setState(() {
      _selectedClub = club;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Keep AppBar minimal on recording screen
      // appBar: AppBar(title: const Text('Record Swing')),
      body: SafeArea(
        child: _isCameraInitialized
            ? Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _cameraController!.value.aspectRatio,
                    child: CameraPreview(_cameraController!),
                  ),
                  // --- UI Overlays ---
                  // Club Selector at the top
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClubSelector(
                            selectedClubId: _selectedClub?.id,
                            onClubSelected: _onClubSelected,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/clubs');
                            },
                            tooltip: 'Manage Clubs',
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Recording Button at the bottom
                  Positioned(
                    bottom: 30,
                    child: FloatingActionButton.large(
                      // Make button larger
                      onPressed: _isRecording
                          ? null
                          : _startRecording, // Disable while recording
                      backgroundColor: _isRecording
                          ? Colors.grey
                          : Theme.of(context)
                              .floatingActionButtonTheme
                              .backgroundColor,
                      child: Icon(
                          _isRecording
                              ? Icons.fiber_manual_record
                              : Icons.videocam,
                          color: _isRecording ? Colors.red : Colors.white,
                          size: 40),
                    ),
                  ),
                  // Optional: Recording Timer
                  if (_isRecording)
                    Positioned(
                      top: 100, // Adjust position
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          children: [
                            Icon(Icons.circle, color: Colors.red, size: 16),
                            SizedBox(width: 8),
                            Text('REC',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            // TODO: Add actual timer if needed
                          ],
                        ),
                      ),
                    )
                ],
              )
            : const Center(
                child: Column(
                // Show loading and text
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Initializing Camera..."),
                ],
              )),
      ),
    );
  }
}
