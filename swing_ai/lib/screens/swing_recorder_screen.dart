import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/club.dart';
import '../widgets/club_selector.dart';
import '../utils/logger.dart';

class SwingRecorderScreen extends StatefulWidget {
  const SwingRecorderScreen({super.key});

  @override
  State<SwingRecorderScreen> createState() => _SwingRecorderScreenState();
}

class _SwingRecorderScreenState extends State<SwingRecorderScreen>
    with WidgetsBindingObserver {
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isRecording = false;
  bool _isFrontCamera = false;
  Club _selectedClub = Club.driver;
  int _countdownValue = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize the camera
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    // Check and request camera permissions
    final cameraPermission = await Permission.camera.request();
    final microphonePermission = await Permission.microphone.request();

    if (!mounted) return;

    if (cameraPermission.isDenied || microphonePermission.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera and microphone permissions are required'),
        ),
      );
      return;
    }

    try {
      // Get available cameras
      _cameras = await availableCameras();

      if (!mounted) return;

      if (_cameras.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No cameras found on this device')),
        );
        return;
      }

      // Create controller for the selected camera
      final cameraIndex = _isFrontCamera ? 1 : 0;

      // Only use front camera if available, otherwise default to back camera
      final selectedCamera =
          _cameras.length > cameraIndex ? _cameras[cameraIndex] : _cameras[0];

      // Initialize the controller with desired resolution and fps
      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      // Initialize the controller
      await _controller!.initialize();

      if (!mounted) return;

      // Set focus mode
      await _controller!.setFocusMode(FocusMode.auto);

      // Set exposure mode
      await _controller!.setExposureMode(ExposureMode.auto);

      try {
        await _controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);
      } catch (e) {
        Logger.error('Could not lock capture orientation', e);
      }

      if (!mounted) return;

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      Logger.error('Error initializing camera', e);
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error initializing camera: $e')));
    }
  }

  // Start recording with countdown
  void _startCountdown() {
    setState(() {
      _countdownValue = 3;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        _countdownValue = 2;
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;

        setState(() {
          _countdownValue = 1;
        });

        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;

          setState(() {
            _countdownValue = 0;
          });
          _startRecording();
        });
      });
    });
  }

  // Start video recording
  Future<void> _startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (_controller!.value.isRecordingVideo) {
      return;
    }

    try {
      // Start recording video
      await _controller!.startVideoRecording();

      if (!mounted) return;

      setState(() {
        _isRecording = true;
      });

      // Record for 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (_isRecording && mounted) {
          _stopRecording();
        }
      });
    } catch (e) {
      Logger.error('Error starting video recording', e);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting video recording: $e')),
      );
    }
  }

  // Stop video recording
  Future<void> _stopRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (!_controller!.value.isRecordingVideo) {
      return;
    }

    try {
      // Stop recording and get the file
      final XFile videoFile = await _controller!.stopVideoRecording();

      if (!mounted) return;

      setState(() {
        _isRecording = false;
      });

      // Navigate to the analysis screen with the video path and selected club
      Navigator.of(context).pushNamed(
        '/analyzing',
        arguments: {'videoPath': videoFile.path, 'club': _selectedClub},
      );
    } catch (e) {
      Logger.error('Error stopping video recording', e);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error stopping video recording: $e')),
      );
    }
  }

  // Switch between front and back cameras
  void _toggleCamera() async {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
      _isInitialized = false;
    });

    await _controller?.dispose();
    _controller = null;

    _initializeCamera();
  }

  // Handle club selection
  void _onClubSelected(Club club) {
    setState(() {
      _selectedClub = club;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          // Camera preview
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.previewSize!.height,
                height: _controller!.value.previewSize!.width,
                child: CameraPreview(_controller!),
              ),
            ),
          ),

          // UI overlay
          SafeArea(
            child: Column(
              children: [
                // Top bar with app name and camera toggle
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'SwingAI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.flip_camera_ios,
                          color: Colors.white,
                        ),
                        onPressed: _toggleCamera,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Countdown display
                if (_countdownValue > 0)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        '$_countdownValue',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Club selector and record button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Club selector
                      ClubSelector(
                        selectedClub: _selectedClub,
                        onClubSelected: _onClubSelected,
                      ),

                      const SizedBox(height: 24),

                      // Record button
                      GestureDetector(
                        onTap: _isRecording ? null : _startCountdown,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isRecording ? Colors.red : Colors.white,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Center(
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isRecording ? Colors.white : Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Tap to record your swing',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Selected: ${_selectedClub.name}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
