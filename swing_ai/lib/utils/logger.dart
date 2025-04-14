import 'package:flutter/foundation.dart';

class Logger {
  static void log(String message) {
    // Only log in debug mode
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  static void error(String message, [dynamic error]) {
    // Error logs are important even in release mode
    if (kDebugMode) {
      debugPrint('ERROR: $message');
      if (error != null) {
        debugPrint(error.toString());
      }
    }
    // In a production app, you would send these to a remote logging service
  }
}
