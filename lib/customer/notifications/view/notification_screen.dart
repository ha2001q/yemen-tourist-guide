import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/images.dart';
import '../../../core/utils/styles.dart';
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
        title: Text("الإشعارات",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Obx(() {
          if (controller.notifications.isEmpty) {
            return Center(child: Text("لا توجد إشعارات حالياً"));
          }

          return Wrap(
            spacing: 10, // Horizontal space between items
            runSpacing: 10, // Vertical space between rows
            children: List.generate(controller.notifications.length, (index) {
              final notification = controller.notifications[index];
              return Container(


                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xffF5F4F8)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      /// image
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image:
                                 const DecorationImage(
                                image:AssetImage(Images.profileNonImage),
                                fit: BoxFit.cover)

                            )
                          ),



                      SizedBox(width: 12,),

                      /// data
                      ///

                      SizedBox(
                        width: 274,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // SizedBox(width: double.infinity,),
                            /// name
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(notification['title']!,style: fontMediumBold,),


                              ],
                            ),

                            /// message
                            Text(notification['message']!,style: TextStyle(color: Colors.grey),),

                            SizedBox(height: 10,),

                            /// time
                            Text(notification['time']!,style: TextStyle(color: Colors.grey))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
