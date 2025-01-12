import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';
import 'package:yemen_tourist_guide/customer/add_review/view/review_screen.dart';
import 'package:yemen_tourist_guide/customer/homePage/controller/home_controller.dart';
import 'package:yemen_tourist_guide/customer/place_details/controller/page_detail_controller.dart';
import 'package:yemen_tourist_guide/customer/place_details/data/grant_location.dart';
import 'package:yemen_tourist_guide/customer/place_details/view/widgets/image_slider_widget.dart';

import '../../../core/utils/images.dart';
import '../../../core/utils/styles.dart';
import '../../favorite_screen/view/pages/favorite_screen.dart';
import '../../homePage/home_view/widgets/ServicesCard.dart';

class PlaceDetails extends StatelessWidget {
  final PageDetailController pageDetailController =
  Get.put(PageDetailController(), permanent: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GetX<PageDetailController>(
          init: pageDetailController, // Initialize the controller
          builder: (controller) {
            final placeData = controller.placeData.value;

            if (placeData == null) {
              return const Center(child: CircularProgressIndicator()); // Loading indicator
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Place image with back and favorite button
                Stack(
                  children: [
                    ImageSliderWidget(images: placeData['place_image'] ?? ['']),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: InkWell(
                        onTap: () {
                          UserDataController.loadUser();
                          var id = UserDataController.userId;
                          if (id == '') {
                            Get.snackbar('Error', 'You have to login first');
                            Get.toNamed('/login');
                          } else {
                            controller.addFavorite(
                              controller.placeIdd.value,
                              id,
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: controller.isRed.value
                                ? const Color(0xFFE17055)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Place details
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: Color(0xFFE17055), size: 20),
                          const SizedBox(width: 5),
                          Text(
                            placeData['place_location'] ?? '',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Place name
                      Text(
                        placeData['place_name'] ?? '',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 15),

                      // Description
                      Text(
                        placeData['place_description'] ?? '',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      const SizedBox(height: 20),

                      // Rating and time
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          InkWell(
                            onTap: () {
                              UserDataController.loadUser();
                              var id = UserDataController.userId;
                              if (id == "") {
                                Get.toNamed('login');
                                return;
                              }
                              Get.toNamed('/add_review', arguments: {
                                'place_id': placeData['place_id']
                              });
                            },
                            child: Text(placeData['rate_avg'] ?? ""),
                          ),
                          const SizedBox(width: 20),
                          TextButton(
                            onPressed: () {
                              Get.toNamed('/comments', arguments: {
                                'place_id': placeData['place_id']
                              });
                            },
                            child:  Text(
                              'readComment'.tr,
                              style: TextStyle(color: Color(0xFFE17055)),
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.time_to_leave, size: 20),
                          const Text(' 30 دقيقة بالسيارة'),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Services section
                       Text('Services at this place'.tr,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),

                      // Services list
                      GetX<HomeController>(
                        init: controller.homeController,
                        builder: (homeController) {
                          return Wrap(
                            spacing: 30,
                            runSpacing: 10,
                            children: homeController.services
                                .map((service) => ServicesCard(
                              onTap: () async{
                                if (pageDetailController.placeData.value != null) {
                                  var check = await requestLocationPermission();
                                  if (!check!) return;

                                  var place = service;
                                  if (place!['service_latitude'] != null &&
                                      place['service_longitude'] != null) {
                                    Get.toNamed('map_page', arguments: {
                                      'lat': place['service_latitude'],
                                      'lon': place['service_longitude']
                                    });
                                  } else {
                                    Get.snackbar('Error', 'Latitude or Longitude is missing.');
                                  }
                                } else {
                                  Get.snackbar('Error', 'Arguments or place data is missing.');
                                }
                              },
                              title: service['service_name'] ?? '',
                              type: service['service_type'] ?? '',
                              location: service['service_location'] ?? '',
                              rating: service['rating']?.toDouble() ?? 0.0,
                              reviews: service['reviews'] ?? 0,
                              imageBath: service['service_images'] ??
                                  'https://via.placeholder.com/150',
                            ))
                                .toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () async {
            if (pageDetailController.placeData.value != null) {
              var check = await requestLocationPermission();
              if (!check!) return;

              var place = pageDetailController.placeData.value;
              if (place!['Place_latitude'] != null &&
                  place['Place_longitude'] != null) {
                Get.toNamed('map_page', arguments: {
                  'lat': place['Place_latitude'],
                  'lon': place['Place_longitude']
                });
              } else {
                Get.snackbar('Error', 'Latitude or Longitude is missing.');
              }
            } else {
              Get.snackbar('Error', 'Arguments or place data is missing.');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE17055),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(Images.roadMap),
              const SizedBox(width: 10),
              Text(
                'viewRoad'.tr,
                style: TextStyle(fontSize: 18,color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
