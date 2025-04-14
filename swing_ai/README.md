# SwingAI - AI-Powered Golf Swing Analyzer

SwingAI is a mobile application that uses AI to analyze golf swings and provide personalized feedback to help golfers improve their game.

## Features

- **Swing Recording**: Record your golf swing with your smartphone camera
- **AI Analysis**: Get detailed metrics including swing speed, ball speed, and carry distance
- **Error Detection**: Identify common swing errors like over-the-top, early extension, and casting
- **Pro Tips**: Receive personalized tips to improve your swing
- **Progress Tracking**: Track your improvement over time

## Technology Stack

- **Frontend**: Flutter for cross-platform mobile development
- **AI/ML**: MediaPipe for pose tracking and TensorFlow Lite for analysis
- **Backend**: Firebase (Authentication, Firestore, Storage)

## Installation

### Prerequisites

- Flutter SDK (latest version)
- Android Studio / Xcode
- Firebase account (for production version)

### Setup

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/swing_ai.git
   ```

2. Navigate to the project directory:
   ```
   cd swing_ai
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

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
