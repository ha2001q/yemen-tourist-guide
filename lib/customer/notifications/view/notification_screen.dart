import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('notification'.tr,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.black),
            onPressed: () {
              controller.deleteAllNotifications();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Obx(() {
          if (controller.notifications.isEmpty) {
            return Center(child: Text('noNotification'.tr));
          }

          return ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];

              return Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xffF5F4F8),
                ),
                child: Row(
                  children: [
                    /// Image
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: AssetImage("assets/images/logo.png"), // Replace with actual path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),

                    /// Data
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Name
                          Text(notification['title']!, style: TextStyle(fontWeight: FontWeight.bold)),

                          /// Message
                          Text(notification['message']!, style: TextStyle(color: Colors.grey)),

                          SizedBox(height: 5),

                          /// Time
                          Text(notification['time']!, style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
