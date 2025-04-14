import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

import '../models/user.dart';
import '../models/swing_analysis.dart';
import '../utils/logger.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Authentication methods

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Logger.error('Error registering user', e);
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Logger.error('Error signing in', e);
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      Logger.error('Error signing out', e);
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      Logger.error('Error resetting password', e);
      rethrow;
    }
  }

  // Firestore user methods

  // Create user document in Firestore
  Future<void> createUserDocument(SwingUser user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      Logger.error('Error creating user document', e);
      rethrow;
    }
  }

  // Get user document from Firestore
  Future<SwingUser?> getUserDocument(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return SwingUser.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      Logger.error('Error getting user document', e);
      rethrow;
    }
  }

  // Update user document
  Future<void> updateUserDocument(SwingUser user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      Logger.error('Error updating user document', e);
      rethrow;
    }
  }

  // Swing analysis methods

  // Save swing analysis to Firestore
  Future<void> saveSwingAnalysis(SwingAnalysis analysis) async {
    try {
      // First save the video to Firebase Storage
      final videoUrl = await _uploadVideoToStorage(
        analysis.videoUrl,
        analysis.userId,
      );

      // Create a map from the analysis
      final analysisData = analysis.toFirestore();

      // Update the video URL with the Firebase Storage URL
      analysisData['videoUrl'] = videoUrl;

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(analysis.userId)
          .collection('swings')
          .doc(analysis.id)
          .set(analysisData);
    } catch (e) {
      Logger.error('Error saving swing analysis', e);
      rethrow;
    }
  }

  // Get list of user's swing analyses
  Future<List<SwingAnalysis>> getUserSwingHistory(
    String userId, {
    int limit = 10,
  }) async {
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('swings')
              .orderBy('timestamp', descending: true)
              .limit(limit)
              .get();

      return snapshot.docs
          .map((doc) => SwingAnalysis.fromFirestore(doc))
          .toList();
    } catch (e) {
      Logger.error('Error getting user swing history', e);
      rethrow;
    }
  }

  // Upload video to Firebase Storage
  Future<String> _uploadVideoToStorage(String videoPath, String userId) async {
    try {
      // Create a unique filename for the video
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(videoPath)}';
      final storageRef = _storage.ref().child('users/$userId/swings/$fileName');

      // Upload the video file
      final uploadTask = await storageRef.putFile(File(videoPath));

      // Get the download URL
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      Logger.error('Error uploading video to storage', e);
      throw Exception('Failed to upload video');
    }
  }

  // Update user's daily analysis count
  Future<void> incrementUserDailyAnalysisCount(String userId) async {
    try {
      // Get the current user document
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final SwingUser user = SwingUser.fromMap(userData, userDoc.id);

        // Check if we need to reset the daily count (new day)
        final lastAnalysisDate = user.lastAnalysisDate;
        final now = DateTime.now();

        if (lastAnalysisDate.day != now.day ||
            lastAnalysisDate.month != now.month ||
            lastAnalysisDate.year != now.year) {
          // New day, reset count
          await _firestore.collection('users').doc(userId).update({
            'dailyAnalysesUsed': 1,
            'lastAnalysisDate': now.toIso8601String(),
            'totalSwingsAnalyzed': user.totalSwingsAnalyzed + 1,
          });
        } else {
          // Same day, increment count
          await _firestore.collection('users').doc(userId).update({
            'dailyAnalysesUsed': user.dailyAnalysesUsed + 1,
            'lastAnalysisDate': now.toIso8601String(),
            'totalSwingsAnalyzed': user.totalSwingsAnalyzed + 1,
          });
        }
      }
    } catch (e) {
      Logger.error('Error incrementing user daily analysis count', e);
      rethrow;
    }
  }
}
