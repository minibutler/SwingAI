# SwingAI - Golf Swing Analyzer

An AI-powered golf swing analyzer built with Flutter that uses computer vision and motion sensors to provide real-time swing metrics and error detection.

## Features

- Record and analyze golf swings using your smartphone camera
- View detailed metrics: swing speed, ball speed, and estimated carry distance
- Detect swing errors with AI-powered analysis
- Support for all clubs in a standard golf bag
- Store and track progress over time

## Setup Instructions

### Prerequisites

- Flutter SDK (3.19.0 or later)
- Android Studio or Xcode for device deployment
- A physical device for testing (simulator/emulator lacks camera and sensors support)

### Installation

1. Clone the repository:
```
git clone https://github.com/yourusername/swing_ai.git
cd swing_ai
```

2. Install dependencies:
```
flutter pub get
```

3. Run the app in debug mode:
```
flutter run
```

## Testing the Product

### Basic Flow

1. Launch the app
2. Select a club from the dropdown menu
3. Position your phone to properly frame your golf swing
4. Tap the record button and perform your swing
5. View the analysis results, including:
   - Swing speed
   - Ball speed
   - Estimated carry distance
   - Detected swing errors

### Camera Positioning

- **Down-the-line View**: Camera placed on the target line, behind the golfer
- **Face-on View**: Camera placed perpendicular to the target line

### Demo Data

The app currently uses generated sample data for development until the ML models are fully trained. The metrics are based on realistic ranges for each club type.

## AI Model Training

### Model Architecture

The app uses two primary AI components:

1. **Pose Detection**: MediaPipe Pose for human pose estimation
2. **Swing Analysis**: Custom TensorFlow Lite models for:
   - Swing speed calculation
   - Error detection

### Training Dataset

For complete model training, you'll need to create a dataset with:

1. 500+ golf swing videos (diverse golfers, angles, and clubs)
2. Annotation of key frames (setup, backswing, impact, follow-through)
3. Ground truth values for speed and errors (validated with professional equipment)

The `ml/` directory contains the structure for implementing the AI components:

```
lib/ml/
├── models/        # TensorFlow model interfaces
├── services/      # Analysis and sensor services
└── utils/         # Pose detection and preprocessing
```

### Training Process

1. **Data Collection**:
   - Record swings from multiple angles
   - Annotate error types with LabelBox or similar tool
   - Capture ground truth data with launch monitor for validation

2. **Feature Extraction**:
   - Process raw pose data into feature vectors
   - Extract temporal features from swing sequence

3. **Model Training**:
   - Train error classifiers using TensorFlow
   - Train regression models for swing metrics
   - Export to TensorFlow Lite format

4. **Validation**:
   - Compare against professional launch monitors
   - Validate error detection with golf instructors

## Roadmap

- [ ] Implement actual MediaPipe pose detection
- [ ] Train and integrate TensorFlow models
- [ ] Add sensor fusion for improved accuracy
- [ ] Implement video storage and management
- [ ] Add user profiles and progress tracking
- [ ] Integrate with cloud services for data backup

## Technology Stack

- **Frontend**: Flutter for cross-platform mobile development
- **AI/ML**: MediaPipe for pose tracking and TensorFlow Lite for analysis
- **Backend**: Firebase (Authentication, Firestore, Storage)

## Project Structure

```
swing_ai/
├── lib/
│   ├── models/          # Data models
│   ├── screens/         # UI screens
│   ├── services/        # Business logic and API services
│   ├── utils/           # Utility functions
│   ├── widgets/         # Reusable UI components
│   └── main.dart        # App entry point
├── assets/
│   ├── images/          # Images and icons
│   ├── animations/      # Lottie animations
│   └── models/          # TensorFlow Lite models
└── ...
```

## MVP Development Roadmap

### Phase 1: Core Functionality (Weeks 1-4)
- [x] Camera integration for swing recording
- [x] Basic UI for recording and viewing results
- [ ] Integration with MediaPipe for pose tracking
- [ ] Basic swing speed calculation

### Phase 2: AI Analysis (Weeks 5-8)
- [ ] TensorFlow Lite model for error detection
- [ ] Implement swing metrics (speed, ball speed, distance)
- [ ] Firebase integration for data storage
- [ ] User profiles and history

### Phase 3: Refinement and Testing (Weeks 9-12)
- [ ] Benchmark against professional systems
- [ ] UI/UX polish
- [ ] Performance optimization
- [ ] Beta testing and feedback collection

## Subscription Tiers

- **Free**: 3 swing analyses per day
- **Pro** ($9.99/month): Unlimited analyses, AR overlay
- **Elite** ($29.99/month): Live pro reviews, equipment recommendations

## License

This project is proprietary and confidential.

## Acknowledgements

- [Flutter](https://flutter.dev)
- [TensorFlow Lite](https://www.tensorflow.org/lite)
- [MediaPipe](https://mediapipe.dev)
- [Firebase](https://firebase.google.com)
