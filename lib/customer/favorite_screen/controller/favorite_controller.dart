import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';

class FavoriteController extends GetxController{

  // UserController userController=Get.put(UserController());

  // A list to store the user favorites data.
  var userFavorites = <Map<String, dynamic>>[].obs;
  var placesData = <Map<String, dynamic>>[].obs; // List to store places data.


  // Firestore instance.
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // StreamSubscription to manage the listener.
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _favoritesSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _placesSubscription;


  // Method to listen to user favorites for a specific user_id.
  void listenToUserFavorites(String userId) {
    try {
      // final storage = GetStorage();
      // var userI = storage.read('userId') ?? '';
      // print('*************---------${userI}');
      // if(userI == ''){
      //   return ;
      // }
      var id = userId;
        // Listen to the collection snapshot for a specific user_id.
        _favoritesSubscription = firestore
            .collection('User_favorites')
            .where('user_id', isEqualTo: id)
            .snapshots()
            .listen((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            // Map the documents to a list of maps.
            userFavorites.value = querySnapshot.docs.map((doc) {
              return doc.data();
            }).toList();

            // Fetch places data for the favorite place IDs.
            print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
            final placeIds = userFavorites.map((fav) {
              final placeId = fav['place_id'];
              return placeId is int ? placeId.toString() : placeId;
            }).toList();
            print("Place IDs to fetch: $placeIds");
            fetchPlacesData(placeIds);

            // Log success.
            print('User favorites updated for userId ${id}: ${userFavorites.length} items.');
          } else {
            // Handle the case where no matching documents are found.
            userFavorites.clear();
            placesData.clear();
            print('No favorites found for userId ${id}.');
          }
        });

    } catch (e) {
      // Handle errors.
      print('Error listening to user favorites for userId ${UserDataController.userId}: $e');
    }
  }
@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    UserDataController.loadUser();
    listenToUserFavorites(UserDataController.userId);

  }
  // Method to fetch places data for a list of place IDs.

  void fetchPlacesData(List<dynamic> placeIds) {
    try {
      print(placeIds[0]);
      // Fetch documents from Places collection where ID is in placeIds.
      _placesSubscription = firestore
          .collection('Places')
          .where('place_id', whereIn: placeIds )
          .snapshots()
          .listen((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Map the documents to a list of maps.
          placesData.value = querySnapshot.docs.map((doc) {
            return doc.data();
          }).toList();

          // Log success.
          print('Places data updated: ${placesData.length} items fetched.');
        } else {
          // Handle the case where no matching documents are found.
          placesData.clear();
          print('No places data found for the given place IDs.');
        }
      });
    } catch (e) {
      // Handle errors.
      print('Error fetching places data: $e');
    }
  }

  void deleteAllUserFavorites() {
    try {
      // Query the collection for documents with the specific user_id.
      UserDataController.loadUser();
      var id = UserDataController.userId;
      firestore
          .collection('User_favorites')
          .where('user_id', isEqualTo: id)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Delete each document returned by the query.
          for (var doc in querySnapshot.docs) {
            FirebaseFirestore.instance
                .collection('User_favorites')
                .doc(doc.id)
                .delete()
                .then((_) async {
              print('Deleted favorite with ID: ${doc.id}');

              // Safely remove the corresponding data from `placesData`
              // int indexToRemove = placesData.value.indexWhere((place) => place['id'] == doc.id);
              // if (indexToRemove != -1) {
              //
              //
              //   placesData.refresh(); // Notify listeners about the change
              // }
              placesData.clear();

            }).catchError((error) {
              print('Error deleting favorite with ID ${doc.id}: $error');
            });
          }



          // Log success after all deletions.
          print('Deleted all favorites for userId ${id}.');
        } else {
          // Handle case where no matching documents are found.
          print('No favorites found to delete for userId ${UserDataController.userId}.');
        }
      }).catchError((error) {
        // Handle errors during the query.
        print('Error querying favorites for userId ${UserDataController.userId}: $error');
      });
    } catch (e) {
      // Handle any unexpected errors.
      print('Error deleting favorites for userId ${UserDataController.userId}: $e');
    }
  }


}
