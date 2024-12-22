import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart'; // If using GetX for state management

class LoginController extends GetxController {
  // Observables for login state (optional, for UI binding)
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  UserController userController = Get.put(UserController());


  // Method to handle login
  Future<bool> loginUser(String phoneNumber, String password) async {
    try {
      // Start loading state
      isLoading.value = true;
      errorMessage.value = '';  // Clear any previous error messages

      // Query the Firestore to find the user with matching phone number and password
      var snapshot = await FirebaseFirestore.instance
          .collection('Users') // Assuming the collection is named 'users'
          .where('user_email', isEqualTo: phoneNumber)
          .where('user_password', isEqualTo: password)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // User found, return true for successful login
        var user = snapshot.docs.first;  // The first document is the matching user
        print('User found: ${user.data()}');

        // You can also store user data locally (e.g., in SharedPreferences) if needed
        // For example, storing user ID:
    // .write('userId', user.id);

        userController.setUser(user.data()['user_id'], user.data()['user_name'], user.data()['user_image']);

        userController.loadUser();
        print('----------------- ${userController.userId.value}');
        // Optional: You can store user data in GetX or other state management libraries

        // Success! Return true
        return true;
      } else {
        // User not found, show an error
        errorMessage.value = 'Invalid phone number or password';
        return false;
      }
    } catch (e) {
      // Error during the Firestore query
      print("Error logging in: $e");
      errorMessage.value = 'Something went wrong. Please try again.';
      return false;
    } finally {
      // Stop loading state
      isLoading.value = false;
    }
  }
}
