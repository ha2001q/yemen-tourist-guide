import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class ProfileController extends GetxController {
  // A variable to store the user data.
  var userData = <String, dynamic>{}.obs;

  // Firestore instance.
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // StreamSubscription to manage the listener.
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _userSubscription;

  // Method to listen to user data for a specific user_id.
  void listenToUser(int userId) {
    try {
      // Listen to the collection snapshot for a specific user_id.
      _userSubscription = firestore
          .collection('Users')
          .where('user_id', isEqualTo: userId)
          .snapshots()
          .listen((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Update the userData observable with the first matching document.
          userData.value = querySnapshot.docs.first.data();

          // Log success.
          print('User data updated for userId $userId: ${userData.value}');
        } else {
          // Handle the case where no matching documents are found.
          userData.value = {};
          print('No user data found for userId $userId.');
        }
      });
    } catch (e) {
      // Handle errors.
      print('Error listening to user data for userId $userId: $e');
    }
  }

  @override
  void onClose() {
    super.onClose();
    // Cancel the subscription when the controller is disposed.
    _userSubscription?.cancel();
  }
}
