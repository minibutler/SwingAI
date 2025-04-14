import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/swing_recorder_screen.dart';
import 'screens/analyzing_screen.dart';
import 'screens/swing_analysis_result_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'models/swing_analysis.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the app to portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase (in production app)
  // await Firebase.initializeApp();

  runApp(const SwingAIApp());
}

class SwingAIApp extends StatelessWidget {
  const SwingAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwingAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3CB143), // Golf green
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3CB143),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF3CB143),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      // For MVP, let's start directly at the home page
      // In a full app with Firebase, we would check authentication status
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/record': (context) => const SwingRecorderScreen(),
        '/history': (context) => const HistoryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/analyzing': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return AnalyzingScreen(
            videoPath: args['videoPath'],
            club: args['club'],
          );
        },
      },
      // For dynamic routes that need parameters
      onGenerateRoute: (settings) {
        if (settings.name == '/results') {
          final args = settings.arguments as SwingAnalysis;
          return MaterialPageRoute(
            builder: (context) => SwingAnalysisResultScreen(analysis: args),
          );
        }
        return null;
      },
    );
  }
}
