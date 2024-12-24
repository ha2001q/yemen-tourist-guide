

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PageDetailRepo{

  Future<bool> checkFavorite( int userId, int placeId) async {
    try {
      if(userId == ''){
        Get.snackbar('Error','you have to login first');
        return false;
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
        Get.snackbar('Info', 'This place is already in your favorites');
        return true;  // Document exists, no need to create it again
      }
      return false;
      // await FirebaseFirestore.instance
      //     .collection('User_favorites')
      //     .doc(documentId)  // Use the concatenated ID
      //     .set({
      //   'place_id': placeId,
      //   'user_id': userId,
      // });
    } catch (e) {
      print("Error creating document: $e");
      return false;
    }
  }
  Future<String> createFavorite( String userId, int placeId) async {
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
        Get.snackbar('Info', 'This place is already in your favorites');
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

}