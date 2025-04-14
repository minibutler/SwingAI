import 'package:flutter/material.dart';
import 'package:swing_ai/screens/analysis_screen.dart'; // Import AnalysisScreen
import 'package:swing_ai/screens/history_screen.dart'; // Import HistoryScreen
import 'package:swing_ai/screens/recording_screen.dart'; // Import RecordingScreen
import 'package:swing_ai/models/swing_data.dart'; // Import SwingData model

// Placeholder for the main application widget
class SwingApp extends StatelessWidget {
  const SwingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwingAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green.shade700, // Darker golf green
            brightness: Brightness.light,
            primary: Colors.green.shade700,
            secondary: Colors.blueGrey.shade600),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade800,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
        ),
        // Add other theme elements (text themes, button themes) for golfer feel
      ),
      debugShowCheckedModeBanner: false,
      // Use MainNavigator for bottom navigation
      home: const MainNavigator(),
      // Define routes for potential named navigation later
      routes: {
        '/recording': (context) => const RecordingScreen(),
        // Removed '/analysis' route as it requires arguments
        '/history': (context) => const HistoryScreen(),
      },
      // Add onGenerateRoute to handle routes that require arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/analysis') {
          // Cast the arguments to the correct type
          final args = settings.arguments;
          if (args is SwingData) {
            return MaterialPageRoute(
              builder: (context) => AnalysisScreen(swingData: args),
            );
          }
          // If args are not SwingData, navigate back to recording screen
          return MaterialPageRoute(
            builder: (context) => const RecordingScreen(),
          );
        }
        // For any other routes
        return null;
      },
    );
  }
}

// Widget to handle Bottom Navigation
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  // Removed 'const' because screen constructors might not be const
  static final List<Widget> _widgetOptions = <Widget>[
    const RecordingScreen(), // Assuming RecordingScreen has a const constructor
    const HistoryScreen(), // Assuming HistoryScreen has a const constructor
    // Add ProfileScreen or SettingsScreen later if needed
    // Placeholder for now:
    Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const Center(child: Text('Settings Placeholder'))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam_outlined),
            activeIcon: Icon(Icons.videocam),
            label: 'Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings', // Placeholder
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey.shade600,
        onTap: _onItemTapped,
      ),
    );
  }
}
