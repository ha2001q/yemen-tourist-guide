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
      isLoading.value = true;
      // Create the comment data
      final commentData = {
        'user_id': userController.userId.value,
        'place_id': placeId,
        'rate': rate,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(), // Server-side time
        'user_image': userController.userImage.value??'',
        'user_name': userController.userName.value
      };

      // Add the data to Firestore
      await firestore.collection('User_comments').add(commentData);
      await getAndUpdateAvgReviewPlace(placeId);

      isLoading.value = false;
      print('Comment added successfully for userId ${userController.userId.value} and placeId $placeId.');
    } catch (e) {
      isLoading.value = false;
      print('Error adding comment for userId ${userController.userId.value} and placeId $placeId: $e');
    }
  }



  Future<void> getAndUpdateAvgReviewPlace(String placeId) async {
    try {
      // Query the collection to get all user comments for the given placeId
      final querySnapshot = await firestore
          .collection('User_comments')
          .where('place_id', isEqualTo: placeId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Extract ratings from the documents
        List<double> ratings = querySnapshot.docs.map((doc) {
          var rate = doc['rate'];
          // Ensure rate is converted to double
          return rate is double ? rate : double.parse(rate.toString());
        }).toList();

        print(ratings);

        // Calculate total rating
        double totalRating = ratings.reduce((a, b) => a + b);

        // Calculate average rating
        double avgRating = double.parse((totalRating / ratings.length).toStringAsFixed(2));


        // Get the total number of reviews
        int reviewCount = ratings.length;

        // Update the place with the new average rating and review count
        await updatePlace(placeId, avgRating.toString(), reviewCount.toString());

        print("Average Rating: $avgRating, Total Reviews: $reviewCount");
      } else {
        print("No comments found for this place.");
      }
    } catch (e) {
      print("Error getting average review: $e");
    }
  }

  Future<void> updatePlace(String placeId, String rateAvg, String reviewNum) async {
    try {
      // Query the document with the specific placeId
      final querySnapshot = await firestore
          .collection('Places')
          .where('place_id', isEqualTo: placeId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document ID and update the fields
        final docId = querySnapshot.docs.first.id;
        await firestore.collection('Places').doc(docId).update({
          'rate_avg': rateAvg,
          'review_num': reviewNum,
        });
        print("Place updated successfully.");
      } else {
        print("Place not found.");
      }
    } catch (e) {
      print("Error updating place: $e");
    }
  }


  @override
  void onInit() {
    super.onInit();
    userController.setUser('1', 'dheya', 'https://s.france24.com/media/display/cc2f52c0-b4eb-11ea-a534-005056a964fe/w:1280/p:16x9/yemen%20houthi%20sanaa%20reuters.jpg');

    userController.loadUser();

  }

}