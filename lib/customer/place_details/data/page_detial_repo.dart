

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PageDetailRepo{

  Future<bool> checkIfIsFavorite(String userId, String placeId) async {
    try {
      if (userId == '') {
        Get.snackbar('Error', 'You have to login first');
        return false;
      }

      // Query Firestore to check if the document exists
      var docSnapshot = await FirebaseFirestore.instance
          .collection('User_favorites')
          .where('place_id', isEqualTo: placeId)
          .where('user_id', isEqualTo: userId)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        // If the document exists, show a message
        // Get.snackbar('Info', 'This place is already in your favorites');
        return true; // Document exists
      }

      return false; // Document does not exist
    } catch (e) {
      print("Error checking document: $e");
      return false;
    }
  }

  Future<String> createFavorite(String userId, String placeId) async {
    try {
      if(userId == ''){
        Get.snackbar('Error','you have to login first');
        return 'login';
      }
      // Create a unique document ID by combining userId and placeId
      String documentId = '${userId}_$placeId';

      // Check if the document already exists
      var docSnapshot = await FirebaseFirestore.instance
          .collection('User_favorites')
          .doc(documentId)
          .get();

      if (docSnapshot.exists) {
        // If the document exists, show a message
        // Get.snackbar('Info', 'This place is already in your favorites');
        var docSnapshott = await FirebaseFirestore.instance
            .collection('User_favorites')
            .doc(documentId)
            .delete();
        return 'delete';  // Document exists, no need to create it again
      }
      await FirebaseFirestore.instance
          .collection('User_favorites')
          .doc(documentId)  // Use the concatenated ID
          .set({
        'place_id': placeId,
        'user_id': userId,
      });
      Get.snackbar('Success','Favorite added');
      return 'done';
    } catch (e) {
      print("Error creating document: $e");
      return 'crash';
    }
  }

  Stream<Map<String, dynamic>?> getPlaceByPlaceId(String placeId) {
    try {
      // Return a stream of snapshots
      return FirebaseFirestore.instance
          .collection('Places')
          .where('place_id', isEqualTo: placeId)
          .limit(1) // Limit to one document for efficiency
          .snapshots()
          .map((querySnapshot) {
        // If there are documents in the snapshot, return the first document
        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          return {"place_id": doc.id, ...doc.data()};
        } else {
          // If no document is found, return null
          return null;
        }
      });
    } catch (e) {
      // Log and return a stream with null in case of an error
      print("Error fetching place by placeId: $e");
      return Stream.value(null); // Emit null if there's an error
    }
  }




}