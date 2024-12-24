import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class CommentController extends GetxController{

  var argument=Get.arguments;

  var placeData = <String, dynamic>{}.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  


  // Method to fetch a place by its place_id
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
          return {"id": doc.id, ...doc.data() as Map<String, dynamic>};
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

 @override
  void onInit() {
    super.onInit();
    
    getPlaceByPlaceId(argument['place_id']).listen((event) { });
    try {
      // Subscribe to the stream from the repository method
      getPlaceByPlaceId(argument['place_id']).listen((data) {
        // Update the reactive variable with the new data
        placeData.value = data!;
      }, onError: (e) {
        print("Error fetching place: $e");
      });
    } catch (e) {
      print("Error fetching place: $e");
    }
  }


}