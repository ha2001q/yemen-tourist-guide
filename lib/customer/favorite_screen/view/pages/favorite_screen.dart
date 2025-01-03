
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';
import 'package:yemen_tourist_guide/customer/favorite_screen/controller/favorite_controller.dart';
import 'package:yemen_tourist_guide/customer/favorite_screen/view/widgets/add_favorite.dart';
import 'package:yemen_tourist_guide/customer/homePage/controller/home_controller.dart';
import 'package:yemen_tourist_guide/customer/homePage/home_view/widgets/PlaceCard.dart';

import '../../../../core/utils/images.dart';
import '../../../../core/utils/styles.dart';
import '../../../homePage/home_view/widgets/ServicesCard.dart';
import '../widgets/favorite_appbar.dart';
class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});
  FavoriteController favoriteController=Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FavoriteAppBar(
        title:'favorite'.tr,
        // icon:SvgPicture.asset(Images.trushIcon,) as Icon ,
        onTap: (){
          favoriteController.deleteAllUserFavorites();
          Navigator.pop(context);
        },),
      body: favoriteController.placesData.isEmpty
          ?const AddFavorite()
          : Obx(
              (){
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              // Text('${favoriteController.placesData.length.toString()} elements'.tr,style: fontLarge,),
                            ],
                          ),
                        ),
                        GridView.count(
                          crossAxisCount: 2, // Number of columns in the grid
                          crossAxisSpacing: 10, // Space between items horizontally
                          mainAxisSpacing: 10, // Space between items vertically
                          childAspectRatio: 3 / 4, // Adjust the card's width-to-height ratio
                          shrinkWrap: true, // Ensures the GridView doesn't take infinite height
                          physics: const NeverScrollableScrollPhysics(),
                          children: favoriteController.placesData.map((placeData) {
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: PlaceCard(
                                title: placeData['place_name'].toString(),
                                location: placeData['place_location'].toString(),
                                imagePath: placeData['place_image'][0],
                                reviews: int.parse(placeData['review_num']),
                                rating: double.parse(placeData['rate_avg']),
                                onTap: () {
                                  Get.toNamed(
                                    '/placeDetailes',
                                    arguments: {'place': placeData['place_id']},
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),

                      ],
                    )



                  ],
                                ),
                );
              }
            ),



    );
  }
}
