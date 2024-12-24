import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/customer/comment_screen/view/comment_screen.dart';

class CommentController extends GetxController{

  var argument=Get.arguments;

  var placeData = <String, dynamic>{}.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  // Method to fetch a place by its place_id
  Future<Map<String, dynamic>?> fetchPlaceById(placeId) async {
    try {
      // Query the Places collection for the specific place_id
      final querySnapshot = await _firestore
          .collection('Places')
          .where('place_id', isEqualTo: placeId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the first matching document's data
        placeData.value = querySnapshot.docs.first.data();
        return querySnapshot.docs.first.data();
      } else {
        print("No place found with the given place_id: $placeId");
        return null;
      }
    } catch (e) {
      print("Error fetching place: $e");
      return null;
    }
  }



  // Fetch comments using the placeId provided during initialization
  Future<void> fetchComments() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Comments')
          .where('place_id', isEqualTo: 1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> comments = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        print("Fetched comments: $comments");
      } else {
        print("No comments found for this place.");
      }
    } catch (e) {
      print("Error fetching comments: $e");
    }
  }




}