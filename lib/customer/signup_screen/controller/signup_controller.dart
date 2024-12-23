import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  // Observables for signup state (optional, for UI binding)
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  // Method to handle user signup
  Future<bool> signupUser(String fullName, String email, String password) async {
    try {
      // Start loading state
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      // Check if the email is already in use
      var snapshot = await FirebaseFirestore.instance
          .collection('Users') // Assuming the collection is named 'users'
          .where('user_email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Email already exists
        errorMessage.value = 'Email is already in use';
        return false;
      }

      // Create a new user in Firestore
      await FirebaseFirestore.instance.collection('Users').add({
        'user_name': fullName,
        'user_email': email,
        'user_password': password, // Ensure this is securely hashed in production
        'user_created_at': FieldValue.serverTimestamp(),
      });

      // Success! Return true
      successMessage.value = 'Account created successfully';
      return true;
    } catch (e) {
      // Error during the Firestore operation
      print("Error signing up: $e");
      errorMessage.value = 'Something went wrong. Please try again.';
      return false;
    } finally {
      // Stop loading state
      isLoading.value = false;
    }
  }
}
