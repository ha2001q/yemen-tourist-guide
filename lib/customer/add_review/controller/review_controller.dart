import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';

import '../../place_details/data/page_detial_repo.dart';

class ReviewController extends GetxController{


  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  UserController userController = Get.put(UserController());



  // Stream to listen to user comments
  Stream<List<Map<String, dynamic>>> listenToUserComments() {
    try {
      return firestore
          .collection('User_comments')
          .where('user_id', isEqualTo: userController.userId.value)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print('Error listening to comments: $e');
      return Stream.empty();
    }
  }

  // Function to add a comment
  Future<void> addComment({
    required double rate,
    required String message,
    required String placeId,
  }) async {
    try {
      // Create the comment data
      final commentData = {
        'user_id': userController.userId.value,
        'place_id': placeId,
        'rate': rate,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(), // Server-side time
      };

      // Add the data to Firestore
      await firestore.collection('User_comments').add(commentData);

      print('Comment added successfully for userId ${userController.userId.value} and placeId $placeId.');
    } catch (e) {
      print('Error adding comment for userId ${userController.userId.value} and placeId $placeId: $e');
    }
  }
}