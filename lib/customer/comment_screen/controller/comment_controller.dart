import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';


class CommentController extends GetxController{

  var argument=Get.arguments;

  var placeData = <String, dynamic>{}.obs;

  var commentData = <Map<String, dynamic>>[].obs;

  // UserController userController=Get.put(UserController());




  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _userSubscription;


  // void listenToUser() {
  //   try {
  //     // Listen to the collection snapshot for a specific user_id.
  //     _userSubscription = _firestore
  //         .collection('Users')
  //         .where('user_id', isEqualTo: userController.userId.value)
  //         .snapshots()
  //         .listen((querySnapshot) {
  //       if (querySnapshot.docs.isNotEmpty) {
  //         // Update the userData observable with the first matching document.
  //         userData.value = querySnapshot.docs.first.data();
  //
  //         // Log success.
  //         print('User data updated for userId ${userController.userId.value}: ${userData.value}');
  //       } else {
  //         // Handle the case where no matching documents are found.
  //         userData.value = {};
  //         print('No user data found for userId ${userController.userId.value}.');
  //       }
  //     });
  //   } catch (e) {
  //     // Handle errors.
  //     print('Error listening to user data for userId ${userController.userId.value}: $e');
  //   }
  // }


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
  Stream<List<Map<String, dynamic>>> fetchComments(String placeId) {
    try {
      return FirebaseFirestore.instance
          .collection('User_comments')
          .where('place_id', isEqualTo: placeId)
          .snapshots() // Use snapshots() to listen to real-time updates
          .map((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Convert the query snapshot into a list of maps
          return querySnapshot.docs
              .map((doc) => doc.data())
              .toList();
        } else {
          return [];
        }
      });
    } catch (e) {
      print("Error fetching comments: $e");
      return Stream.value([]); // Return an empty stream in case of an error
    }
  }



  @override
  void onInit() {
    super.onInit();

    getPlaceByPlaceId(argument['place_id']).listen((event) {
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
    });



    print(argument['place_id']);
    fetchComments(argument['place_id']).listen(
          (comments) {
        // Handle the new list of comments here
        print("New comments: $comments");
        // You can update your state or UI here
        commentData.value = comments;  // Example of updating commentData (if you're using something like ValueNotifier)
      },
      onError: (error) {
        // Handle errors here
        print("Error fetching comments: $error");
      },
    );
  }
}