import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/customer/favorite_screen/controller/favorite_controller.dart';
import 'package:yemen_tourist_guide/customer/homePage/home_view/widgets/PlaceCard.dart';

import '../../../../core/utils/images.dart';
import '../../../../core/utils/styles.dart';
import '../../../homePage/home_view/widgets/ServicesCard.dart';
import '../widgets/favorite_appbar.dart';
class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});
  FavoriteController favoriteController=Get.put(FavoriteController());



  // FavoriteScreen({super.key}) {
  //   // Call listenToUser in the constructor.
  //   favoriteController.listenToUserFavorites(userId);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FavoriteAppBar(
        title:"Favorite",
        // icon:SvgPicture.asset(Images.trushIcon,) as Icon ,
        onTap: () => {},),
      body:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                Obx(() {
                  return Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Text("${favoriteController.placesData.length.toString()} elements",style: fontLarge,),
                            ],
                          ),
                        ),
                        Wrap(
                          spacing: 30, // Space between items horizontally
                          runSpacing: 10, // Space between items vertically
                          children: favoriteController.placesData.map((placeData) {
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child:
                            PlaceCard(title: placeData['place_name'].toString(),
                              location: placeData['place_location'].toString(),
                            imagePath: placeData['place_image'][0],
                            reviews: int.parse(placeData['review_num']),
                            rating: double.parse(placeData['rate_avg']), onTap: () {  },
                            ),
                          );
                        }).toList(),
                                        ),
                      ],
                    ),
                  );
                })



              ],
            ),



    );
  }
}
