import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart'; // If using GetX for state management

class LoginController extends GetxController {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpWithGoogle(BuildContext context) async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign-Up Cancelled")),
        );
        return;
      }

      // Obtain Google authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a credential for Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign up with Firebase using Google credentials
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      //fech user token
      String? token = await FirebaseMessaging.instance.getToken();

      if (user != null) {
        // Save user data in Firestore
        await _firestore.collection("Users").doc(user.uid).set({
          "user_id": user.uid,
          "user_name": user.displayName,
          "user_email": user.email,
          "user_image": user.photoURL,
          "user_created_at": DateTime.now(),
          "user_token":token
        });

        UserDataController.setUser(user.uid, user.displayName.toString(), user.photoURL.toString());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign-Up Successful! Welcome, ${user.displayName}")),
        );

        Get.toNamed('/root');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-Up Failed: $e")),
      );

      print("Sign-Up Failed: $e");
    }
  }


  Future<void> logout() async {
    try {
      // Sign out from Google
      await _googleSignIn.signOut();

      // Sign out from Firebase
      await _auth.signOut();

      Get.snackbar("Logged Out", "You have successfully logged out.");
    } catch (e) {
      Get.snackbar("Logout Failed", e.toString());
    }
  }





  // Observables for login state (optional, for UI binding)
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  // UserController userController = Get.put(UserController());


  // Method to handle login
  Future<bool> loginUser(String email, String password) async {
    try {
      // Start loading state
      isLoading.value = true;
      errorMessage.value = '';  // Clear any previous error messages

      // Query the Firestore to find the user with matching phone number and password
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Users') // Assuming the collection is named 'users'
          .where('user_email', isEqualTo: email)
          .where('user_password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // User found, return true for successful login
        var user = querySnapshot.docs.first;  // The first document is the matching user
        print('User found: ${user.data()}');
        String? token = await FirebaseMessaging.instance.getToken();
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.data()['user_id'])
            .update({'user_token': token});




        // You can also store user data locally (e.g., in SharedPreferences) if needed
        // For example, storing user ID:
    // .write('userId', user.id);

        UserDataController.setUser(user.data()['user_id'], user.data()['user_name'], user.data()['user_image']??'');

        UserDataController.loadUser();
        var id = UserDataController.userId;
        print('----------------- ${id}');
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

  // Future<void> updateUserToken(String userId) async {
  //   try {
  //     // Get the user's FCM token
  //     String? token = await FirebaseMessaging.instance.getToken();
  //
  //     if (token != null) {
  //       // Make an API call to update the token on your backend
  //       var snapshot = await FirebaseFirestore.instance
  //           .collection('Users') // Assuming the collection is named 'users'
  //           .where('userId', isEqualTo: userId)
  //           .get();
  //
  //       if (snapshot.docs.isNotEmpty) {
  //         // User found, return true for successful login
  //         var user = snapshot.docs.first;  // The first document is the matching user
  //         print('User found: ${user.data()}');
  //       } else {
  //         print("Failed to update user token. Status code: ${response.statusCode}");
  //       }
  //     } else {
  //       print("Unable to retrieve FCM token.");
  //     }
  //   } catch (e) {
  //     print("Error updating user token: $e");
  //   }
  // }
}
