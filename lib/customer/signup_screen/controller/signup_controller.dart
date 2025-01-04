import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/common_controller/user_data.dart'; // To generate unique IDs


class SignupController extends GetxController {
  // Observables for signup state
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  // UserController userController = Get.put(UserController());


  // Method to handle user signup
  Future<bool> signupUser(String fullName, String email, String password,String token) async {
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

      // Generate a unique user_id
      String userId = Uuid().v4(); // Use Firebase document ID if preferred

      // Create a new user in Firestore
      await FirebaseFirestore.instance.collection('Users').doc(userId).set({
        'user_id': userId,
        'user_name': fullName,
        'user_email': email,
        'user_password': password, // Ensure this is securely hashed in production
        'user_created_at': FieldValue.serverTimestamp(),
        'user_token':token,
      });
      UserDataController.setUser(userId, fullName,'');

      UserDataController.loadUser();
      print('----------------- ${UserDataController.userId}');
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
