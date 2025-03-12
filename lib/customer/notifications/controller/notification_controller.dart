import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var notifications = <Map<String, String>>[].obs; // Ensure all values are String

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .get();

      notifications.value = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        return {
          'title': (data['title'] ?? 'No Title').toString(),
          'message': (data['body'] ?? 'No Message').toString(),
          'time': data['timestamp'] is Timestamp
              ? (data['timestamp'] as Timestamp)
              .toDate()
              .toLocal()
              .toString()
              .split('.')[0] // Removes milliseconds
              : (data['timestamp'] ?? '').toString(),
        };
      }).toList();
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }


  void deleteAllNotifications() async {
    var batch = _firestore.batch();
    var collection = await _firestore.collection('notifications').get();

    for (var doc in collection.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    notifications.clear();
  }
}
