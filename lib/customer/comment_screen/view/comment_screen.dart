import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/core/utils/styles.dart';
import 'package:yemen_tourist_guide/customer/comment_screen/controller/comment_controller.dart';
import 'package:yemen_tourist_guide/customer/comment_screen/view/widgets/place_review_widget.dart';

import '../../../core/common_controller/user_data.dart';
import '../../../core/utils/images.dart';
import '../../homePage/home_view/widgets/ServicesCard.dart';
class CommentScreen extends StatelessWidget {
   CommentScreen({super.key});

   // UserController userController = Get.put(UserController(), permanent: true);

  CommentController commentController=Get.put(CommentController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Comments'.tr,style: fontLargeBold,),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Obx(() {

        final placeData = commentController.placeData.value;

        if (placeData == null) {
          return Center(child: CircularProgressIndicator()); // Show a loading indicator
        }
        return
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                ServicesCard(
                  title: placeData['place_name']??" ",
                  location: placeData['place_location']??"",
                  imageBath: placeData['place_image'][0]??"https://s.france24.com/media/display/cc2f52c0-b4eb-11ea-a534-005056a964fe/w:1280/p:16x9/yemen%20houthi%20sanaa%20reuters.jpg",
                  reviews: int.parse(placeData['review_num']?? ""),
                  rating: double.parse(placeData['rate_avg']?? ""),
                  type: '',
                  onTap: (){},
                ),
                const SizedBox(height: 20,),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: (){
                          UserDataController.loadUser();
                          UserDataController.loadUser();
                          var id = UserDataController.userId;

                          print('44444444444444$id');
                          if(id == ""){
                            Get.toNamed('login');
                            return;
                          }
                          Get.toNamed('/add_review',arguments: {'place_id':placeData['place_id']});

                        },
                        child: SvgPicture.asset(Images.addComment)
                    ),
                     Text('userComment'.tr,style: fontLarge,),
                  ],
                ),
                SizedBox(height: 10,),
                Wrap(
                  spacing: 8.0, // Horizontal spacing
                  runSpacing: 8.0, // Vertical spacing
                  children: commentController.commentData.map((comment) {
                    return PlaceReviewWidget(
                      image: comment['user_image'],
                      massage: comment['message'].toString(),
                      name: comment['user_name'].toString()??'',
                      rate: comment['rate'].toString(),
                      time: '',
                    );
                  }).toList(),
                )


              ]
            ),
          ),
        );

      }),
    );
  }
}



