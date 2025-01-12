import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationStream {
  // StreamController to manage the email verification stream
  final StreamController<bool> _verificationStatusController = StreamController<bool>.broadcast();

  // Get the stream for email verification status
  Stream<bool> get verificationStatusStream => _verificationStatusController.stream;

  // FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Polling duration
  final Duration pollingInterval = Duration(seconds: 5);

  // Function to check email verification
  Future<void> checkEmailVerification(String email) async {
    try {
      // Get the current user
      User? user = _auth.currentUser;

      // Check if the user is signed in and their email matches the provided email
      if (user != null && user.email == email) {
        // Start a polling mechanism to check verification status every 5 seconds
        Timer.periodic(pollingInterval, (timer) async {
          // Reload the user data to check the verification status
          await user.reload();
          if (user.emailVerified) {
            // If email is verified, stop the timer and update the stream
            _verificationStatusController.sink.add(true);
            timer.cancel(); // Stop the polling once verified
          } else {
            // If not verified, continue checking
            _verificationStatusController.sink.add(false);
          }
        });
      } else {
        // If user is not logged in or email doesn't match, emit false
        _verificationStatusController.sink.add(false);
      }
    } catch (e) {
      // Handle any errors and emit false
      print('Error checking email verification: $e');
      _verificationStatusController.sink.add(false);
    }
  }

  // Dispose method to close the stream controller when done
  void dispose() {
    _verificationStatusController.close();
  }

  Future<bool> isEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();  // Reload the user to get the latest status
      print('email is verfied');
      return user.emailVerified;  // Return whether the email is verified
    } else {
      print('email is not verfied');

      return false;  // If no user is logged in, return false
    }
  }
}
