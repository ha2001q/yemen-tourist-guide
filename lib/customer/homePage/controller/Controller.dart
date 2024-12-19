import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'dart:async';

class PlacesController extends GetxController {

  // A list to store the places data.
  var placesList = <Map<String, dynamic>>[].obs;

  // Firestore instance.
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // StreamSubscription to manage the listener.
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _placesSubscription;

  // Method to listen to places collection updates.
  void listenToPlaces() {
    try {
      // Listen to the collection snapshot.
      _placesSubscription = firestore.collection('Places').snapshots().listen((querySnapshot) {
        // Map the documents to a list of maps.
        placesList.value = querySnapshot.docs.map((doc) {
          return {
            "id": doc.id,
            ...doc.data() as Map<String, dynamic>
          };
        }).toList();

        // Log success.
        print('Places data updated: ${placesList.length} items.');
      });
    } catch (e) {
      // Handle errors.
      print('Error listening to places data: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Start listening to places data when the controller is initialized.
    listenToPlaces();
  }

  @override
  void onClose() {
    super.onClose();
    // Cancel the subscription when the controller is disposed.
    _placesSubscription?.cancel();
  }
}
