import 'package:get/get.dart';

class NotificationController extends GetxController {
  // List to store notifications
  var notifications = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(); // Load notifications when controller is initialized
  }

  // Simulated API call to fetch notifications
  void fetchNotifications() {
    List<Map<String, String>> fetchedNotifications = [
      {
        "title": "صهيب الشهاري",
        "message": "لقد ارسلت لك تحقق من الرسالة في علامة تنوب الرسالة.",
        "time": "منذ 10 دقائق",
        "image": "https://randomuser.me/api/portraits/men/1.jpg"
      },

    ];

    // Update observable list
    notifications.assignAll(fetchedNotifications);
  }
}
