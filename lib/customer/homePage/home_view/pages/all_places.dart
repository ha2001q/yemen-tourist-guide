import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:yemen_tourist_guide/core/utils/styles.dart';
import 'package:yemen_tourist_guide/customer/homePage/controller/home_controller.dart';

import '../widgets/PlaceCard.dart';
class AllPlacesScreen extends StatelessWidget {
  AllPlacesScreen({super.key});

  HomeController homeController=Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:  Text('all_places'.tr,style: fontLargeBold,),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //       onPressed: ()=>Navigator.pop(context),
        //       icon: Icon(Icons.arrow_forward_ios)
        //   )
        // ],
      ) ,
      body:
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 30,),

            Obx(
                    (){
                  return  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        mainAxisSpacing: 20, // Space between rows
                        crossAxisSpacing: 30, // Space between columns
                        childAspectRatio: 3 / 4, // Adjust the card's width-to-height ratio
                      ),
                      itemCount: homeController.places.length, // Number of items
                      shrinkWrap: true, // Ensures GridView doesn't take infinite height
                      physics: const NeverScrollableScrollPhysics(), // Prevents independent scrolling
                      itemBuilder: (context, index) {
                        final place = homeController.places[index];
                        return PlaceCard(
                          title: place['place_name'],
                          location: place['place_location'],
                          rating: double.tryParse(place['rate_avg'] ?? '0.0') ?? 0.0,
                          reviews: int.tryParse(place['review_num'] ?? '0') ?? 0,
                          imagePath: place['place_image']?[0] ?? 'https://tourismteacher.com/wp-content/uploads/2023/10/mosq.jpg',
                          onTap: () {
                            Get.toNamed(
                              '/placeDetailes',
                              arguments: {
                                'place': place['place_id'],
                              },
                            );
                          },
                        );
                      },
                    )

                  );
                }),
          ],
        ),
      ),
    );
  }
}
