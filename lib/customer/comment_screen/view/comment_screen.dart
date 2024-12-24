import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/core/utils/images.dart';
import 'package:yemen_tourist_guide/core/utils/styles.dart';
import 'package:yemen_tourist_guide/customer/comment_screen/controller/comment_controller.dart';

import '../../homePage/home_view/widgets/ServicesCard.dart';
class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});
  

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  CommentController commentController=Get.put(CommentController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments",style: fontLargeBold,),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Obx(() {
        return
        Column(
          children: [
            ServicesCard(
              title: commentController.placeData['place_name'],
              location: commentController.placeData['place_name'],
              imageBath: commentController.placeData['place_name'],
              reviews: int.parse(commentController.placeData['place_name']),
              rating: commentController.placeData['place_name'],
              type: commentController.placeData['place_name'],
              onTap: (){},
            ),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("مراجعات المستخدم",style: fontLarge,),
                InkWell(
                  onTap: (){
                    // Get.toNamed('/add_review',arguments: {'place_id': arguments['place_id']});
                  },
                    child: Image.asset(Images.addComment)
                )
              ],
            ),
            SingleChildScrollView(
            child:ListView.builder(
                reverse: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  // final message = messages[index];
                  return ListTile(
                    // title: Text(message.user),
                    // subtitle: Text(message.message),
                    // trailing: Text(message.timestamp.toString()),
                  );
                },
              )
            )
        ]
        );

      }),
    );
  }
}
