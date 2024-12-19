
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/main.dart';

import '../controller/Controller.dart';

class HomePageScreen extends StatelessWidget {
   HomePageScreen({super.key});
  PlacesController placesController= Get.put(PlacesController(),permanent:true );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: Obx(() {
          // sharedPref!.setString("id", "1");
          return ListView.builder(

            itemCount: placesController.placesList.length,
            itemBuilder: (context, index) {
              final place = placesController.placesList[index];
              return ListTile(
                
                title: Text(place['place_name'] ?? 'Unnamed Place'),
                subtitle: Text(place['place_description'] ?? 'No description'),
              );
            },
          );
        }),
      ),
    );
  }
}
