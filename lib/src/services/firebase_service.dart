import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';

class FirebaseService extends GetxService {
  static FirebaseService get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password (without auto verification)
  Future<UserCredential?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Generate OTP code
  String generateOTP() {
    return (100000 +
            (900000 *
                (DateTime.now().millisecondsSinceEpoch % 1000000) /
                1000000))
        .floor()
        .toString();
  }

  // Store OTP in Firestore
  Future<void> storeOTPInFirestore(String email, String otpCode) async {
    try {
      await _firestore.collection('otps').doc(email).set({
        'otp': otpCode,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(
          DateTime.now().add(Duration(minutes: 10)), // 10-minute expiry
        ),
        'verified': false,
      });
    } catch (e) {
      throw 'Failed to store OTP: ${e.toString()}';
    }
  }

  // Verify OTP from Firestore
  Future<bool> verifyOTPFromFirestore(String email, String otpCode) async {
    try {
      final doc = await _firestore.collection('otps').doc(email).get();

      if (!doc.exists) {
        throw 'No OTP found. Please request a new code.';
      }

      final data = doc.data()!;
      final storedOTP = data['otp'] as String;
      final expiresAt = data['expiresAt'] as Timestamp;
      final verified = data['verified'] as bool;

      // Check if OTP is expired
      if (DateTime.now().isAfter(expiresAt.toDate())) {
        throw 'OTP has expired. Please request a new code.';
      }

      // Check if already verified
      if (verified) {
        throw 'OTP has already been used. Please request a new code.';
      }

      // Check if OTP matches
      if (storedOTP != otpCode) {
        throw 'Invalid OTP code. Please try again.';
      }

      // Mark as verified
      await _firestore.collection('otps').doc(email).update({
        'verified': true,
        'verifiedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      if (e is String) {
        rethrow;
      }
      throw 'Failed to verify OTP: ${e.toString()}';
    }
  }

  // Send OTP to email using Firebase Functions
  Future<void> sendOTPToEmail(String email) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('sendEmailOTP');

      final result = await callable.call({'email': email});

      if (result.data['success'] != true) {
        throw result.data['message'] ?? 'Failed to send OTP';
      }
    } catch (e) {
      if (e.toString().contains('not found')) {
        throw 'OTP service not available. Please ensure Firebase Functions are deployed.';
      }
      throw 'Failed to send OTP: ${e.toString()}';
    }
  }

  // Verify OTP code
  Future<bool> verifyOTP(String email, String otpCode) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('verifyEmailOTP');

      final result = await callable.call({'email': email, 'otp': otpCode});

      return result.data['success'] == true;
    } catch (e) {
      if (e.toString().contains('not found')) {
        throw 'OTP verification service not available. Please ensure Firebase Functions are deployed.';
      }
      throw 'Failed to verify OTP: ${e.toString()}';
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Send email verification (original method - keeping for compatibility)
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Failed to sign out. Please try again.';
    }
  }

  // Delete user account
  Future<void> deleteUser() async {
    try {
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Create user document in Firestore - UPDATED WITH BETTER ERROR HANDLING
  Future<void> createUserDocument(
    String uid,
    String email,
    String username,
  ) async {
    try {
      print('FirebaseService: Creating user document for uid: $uid');

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'username': username,
        'emailVerified': true, // Since they verified via OTP
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('FirebaseService: User document created successfully');
    } on FirebaseException catch (e) {
      print(
        'FirebaseService: Firebase error creating user - Code: ${e.code}, Message: ${e.message}',
      );

      switch (e.code) {
        case 'permission-denied':
          throw 'Access denied. Cannot create user profile.';
        case 'unavailable':
          throw 'Service temporarily unavailable. Please try again.';
        case 'network-request-failed':
          throw 'Network error. Please check your connection.';
        default:
          throw 'Failed to create user profile: ${e.message}';
      }
    } catch (e) {
      print('FirebaseService: Unexpected error creating user: $e');
      throw 'Failed to create user profile: ${e.toString()}';
    }
  }

  // Get user document from Firestore
  Future<DocumentSnapshot> getUserDocument(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      throw 'Failed to get user data. Please try again.';
    }
  }

  // Update user document
  Future<void> updateUserDocument(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update user profile. Please try again.';
    }
  }

  // Check if username is available - UPDATED WITH BETTER ERROR HANDLING
  Future<bool> isUsernameAvailable(String username) async {
    try {
      print('FirebaseService: Checking username availability for: $username');

      // Check if Firestore is accessible
      if (_firestore == null) {
        throw 'Firestore not initialized';
      }

      final querySnapshot =
          await _firestore
              .collection('users')
              .where('username', isEqualTo: username)
              .limit(1) // Only need to know if at least one exists
              .get();

      print(
        'FirebaseService: Query completed. Found ${querySnapshot.docs.length} documents',
      );

      return querySnapshot.docs.isEmpty;
    } on FirebaseException catch (e) {
      print(
        'FirebaseService: Firebase error - Code: ${e.code}, Message: ${e.message}',
      );

      // Handle specific Firebase errors
      switch (e.code) {
        case 'permission-denied':
          throw 'Access denied. Please check your permissions.';
        case 'unavailable':
          throw 'Service temporarily unavailable. Please try again.';
        case 'network-request-failed':
          throw 'Network error. Please check your connection.';
        case 'failed-precondition':
          throw 'Database not ready. Please try again.';
        case 'resource-exhausted':
          throw 'Too many requests. Please try again later.';
        default:
          throw 'Database error: ${e.message}';
      }
    } catch (e) {
      print('FirebaseService: Unexpected error: $e');
      throw 'Failed to check username availability: ${e.toString()}';
    }
  }

  // Test Firebase connection - NEW METHOD FOR DEBUGGING
  Future<void> testFirebaseConnection() async {
    try {
      print('FirebaseService: Testing Firebase connection...');

      // Test auth
      final user = currentUser;
      print('FirebaseService: Current user: ${user?.uid ?? 'No user'}');

      // Test Firestore read
      final testDoc = await _firestore.collection('test').limit(1).get();

      print('FirebaseService: Firestore read test successful');

      // Test Firestore write (if user is authenticated)
      if (user != null) {
        await _firestore.collection('test').doc('connection_test').set({
          'timestamp': FieldValue.serverTimestamp(),
          'user': user.uid,
        });

        print('FirebaseService: Firestore write test successful');
      }
    } catch (e) {
      print('FirebaseService: Connection test failed: $e');
      rethrow;
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Signing in with Email and Password is not enabled.';
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      case 'invalid-verification-id':
        return 'The verification ID is invalid.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}
