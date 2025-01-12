
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:async';

class SignupController extends GetxController {
  // Observables for signup state
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //
  // // StreamController to listen for email verification status
  // final StreamController<bool> _verificationStatusController = StreamController<bool>.broadcast();

  // Method to handle user signup with email verification
  Future<bool> signupUser(String fullName, String email, String password, String token) async {
    try {
      // Start loading state
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      // Step 2: Create the user in Firebase Authentication
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 3: Send email verification
      await userCredential.user?.sendEmailVerification();

      return true;
    } catch (e) {
      // Handle any errors during the signup process
      print("Error signing up: $e");
      errorMessage.value = 'Something went wrong. Please try again.';
      return false;
    } finally {
      // Stop loading state
      isLoading.value = false;
    }
  }
}
