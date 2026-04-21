import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const Duration _requestTimeout = Duration(seconds: 30);
  static const int _maxAttempts = 2;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  static String describeError(Object error) {
    if (error is TimeoutException) {
      return 'Firestore request timed out. Check that Firestore is enabled and your internet is working.';
    }

    if (error is FirebaseException) {
      final String combinedMessage =
          '${error.code} ${error.message ?? ''}'.toLowerCase();

      if (combinedMessage.contains('api has not been used') ||
          combinedMessage.contains('disabled') ||
          combinedMessage.contains('unimplemented')) {
        return 'Firestore API is not enabled for this project. Enable Cloud Firestore in Firebase/Google Cloud Console and try again.';
      }

      if (error.code == 'permission-denied') {
        return 'Firestore access was denied. Check your Firestore security rules.';
      }

      if (error.code == 'unavailable' || error.code == 'deadline-exceeded') {
        return 'Firestore is temporarily unavailable. Check your internet connection and try again.';
      }
    }

    return 'Firestore request failed. Details: $error';
  }

  Future<void> _ensureFirebaseInitialized() async {
    if (Firebase.apps.isNotEmpty) {
      return;
    }

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<T> _runWithRetry<T>({
    required String operationName,
    required Future<T> Function() operation,
  }) async {
    await _ensureFirebaseInitialized();

    for (int attempt = 1; attempt <= _maxAttempts; attempt++) {
      try {
        return await operation().timeout(_requestTimeout);
      } on TimeoutException {
        if (attempt == _maxAttempts) {
          throw TimeoutException(
            'Firestore $operationName timed out after $_maxAttempts attempts.',
            _requestTimeout,
          );
        }
      } on FirebaseException catch (error) {
        final bool isRetryable =
            error.code == 'deadline-exceeded' || error.code == 'unavailable';
        if (!isRetryable || attempt == _maxAttempts) {
          rethrow;
        }
      }

      if (attempt < _maxAttempts) {
        // Brief backoff avoids immediately repeating a failing network call.
        await Future<void>.delayed(const Duration(seconds: 1));
      }
    }

    throw StateError('Unexpected retry state for Firestore $operationName.');
  }

  Future<void> createUser({
    required String name,
    required String email,
    required String phone,
    required String role,
  }) async {
    final String normalizedEmail = email.trim().toLowerCase();

    await _runWithRetry<void>(
      operationName: 'create user',
      operation: () => _usersCollection.doc(normalizedEmail).set({
        'name': name.trim(),
        'email': normalizedEmail,
        'phone': phone.trim(),
        'role': role,
        'createdAt': DateTime.now().toIso8601String(),
      }),
    );
  }

  Future<bool> userExists(String email) async {
    final String normalizedEmail = email.trim().toLowerCase();
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _runWithRetry<DocumentSnapshot<Map<String, dynamic>>>(
      operationName: 'read user existence',
      operation: () => _usersCollection.doc(normalizedEmail).get(),
    );
    return snapshot.exists;
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    final String normalizedEmail = email.trim().toLowerCase();
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _runWithRetry<DocumentSnapshot<Map<String, dynamic>>>(
      operationName: 'read user',
      operation: () => _usersCollection.doc(normalizedEmail).get(),
    );

    return snapshot.data();
  }
}
