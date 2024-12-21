import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all documents from the 'Citys' collection and return all fields of each document
  Stream<List<Map<String, dynamic>>> getAllCities() {
    try {
      return _firestore.collection('Citys').snapshots().map(
            (snapshot) {
          // Map each document to a map (it will contain all the fields of the document)
          return snapshot.docs.map((doc) => doc.data()).toList();
        },
      );
    } catch (e) {
      throw Exception("Error fetching cities: $e");
    }
  }

}
