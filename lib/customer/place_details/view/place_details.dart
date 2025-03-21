import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';
import 'package:yemen_tourist_guide/customer/homePage/controller/home_controller.dart';
import 'package:yemen_tourist_guide/customer/place_details/controller/page_detail_controller.dart';
import 'package:yemen_tourist_guide/customer/place_details/data/grant_location.dart';
import 'package:yemen_tourist_guide/customer/place_details/view/widgets/Service_cart.dart';
import 'package:yemen_tourist_guide/customer/place_details/view/widgets/image_slider_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/images.dart';

class PlaceDetails extends StatelessWidget {
  final PageDetailController pageDetailController =
  Get.put(PageDetailController(), permanent: false);

  void _showFullImage(BuildContext context, List<String> images, int selectedIndex) {
    PageController pageController = PageController(initialPage: selectedIndex);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.9), // Dimmed background
          insetPadding: const EdgeInsets.all(15), // Full-screen effect
          child: Stack(
            alignment: Alignment.center,
            children: [
              // PageView for Swiping Images
              PageView.builder(
                controller: pageController,
                itemCount: images.length,
                physics: const ClampingScrollPhysics(), // Prevents unwanted overscroll
                clipBehavior: Clip.none, // Allows zoomed image to overflow
                itemBuilder: (context, index) {
                  return Center(
                    child: InteractiveViewer(
                      panEnabled: true, // Allow panning while zoomed
                      boundaryMargin: const EdgeInsets.all(5), // Give space for zoom
                      minScale: 1.0,
                      maxScale: 4.0, // Enable zoom up to 4x
                      child: Container(
                        height: double.infinity,
                          width: double.infinity,
                          child: Image.network(images[index], fit: BoxFit.contain)),
                    ),
                  );
                },
              ),

              // Left Arrow Button
              Positioned(
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                  onPressed: () {
                    if (pageController.page! > 0) {
                      pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),

              // Right Arrow Button
              Positioned(
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 30),
                  onPressed: () {
                    if (pageController.page! < images.length - 1) {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),

              // Close Button (Top-Right)
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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


            // String imageUrl = placeData['place_image'][0];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Place image with back and favorite button
                Stack(
                  children: [

                    InkWell(
                      child: ImageSliderWidget(images: placeData['place_image'] ?? ['']),
                      onTap: () => _showFullImage(
                        context,
                        List<String>.from(placeData['place_image'] ?? []),
                        0, // Open from the first image
                      ),
                    ),

                    // ImageSliderWidget(images: placeData['place_image'] ?? ['']),
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
                              style: const TextStyle(color: Color(0xFFE17055)),
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.time_to_leave, size: 20),
                          InkWell(
                            onTap: () async {
                              if (pageDetailController.placeData.value != null) {
                                var check = await requestLocationPermission();
                                if (!check!) return;

                                var place = pageDetailController.placeData.value;
                                if (place!['Place_latitude'] != null && place['Place_longitude'] != null) {
                                  double destinationLat = double.parse(place['Place_latitude']);
                                  double destinationLon = double.parse(place['Place_longitude']);

                                  String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLon&travelmode=driving";

                                  if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
                                    await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
                                  } else {
                                    Get.snackbar('Error', 'Could not open Google Maps.');
                                  }
                                } else {
                                  Get.snackbar('Error', 'Latitude or Longitude is missing.');
                                }
                              } else {
                                Get.snackbar('Error', 'Arguments or place data is missing.');
                              }
                            },
                              child: Text('duration'.tr)
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Services section
                       Text('Services at this place'.tr,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),

                      // Services list
                      GetX<HomeController>(
                        init: controller.homeController,
                        builder: (homeController) {
                          return Wrap(
                            spacing: 30,
                            runSpacing: 10,
                            children: homeController.services
                                .map((service) => ServicesCard1(
                              onTap: () async{
                                if (pageDetailController.placeData.value != null) {
                                  var check = await requestLocationPermission();
                                  if (!check!) return;

                                  var place = service;
                                  // if (place!['service_latitude'] != null &&
                                  //     place['service_longitude'] != null) {
                                  //   Get.toNamed('map_page', arguments: {
                                  //     'lat': place['service_latitude'],
                                  //     'lon': place['service_longitude']
                                  //   });
                                  // }
                                  if (place!['service_latitude'] != null && place['service_longitude'] != null) {
                                    double destinationLat = double.parse(place['service_latitude']);
                                    double destinationLon = double.parse(place['service_longitude']);

                                    String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLon&travelmode=driving";

                                    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
                                      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
                                    } else {
                                      Get.snackbar('Error', 'Could not open Google Maps.');
                                    }
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
                if (place!['Place_latitude'] != null && place['Place_longitude'] != null) {
                  double destinationLat = double.parse(place['Place_latitude']);
                  double destinationLon = double.parse(place['Place_longitude']);

                  String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLon&travelmode=driving";

                  if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
            await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
            } else {
            Get.snackbar('Error', 'Could not open Google Maps.');
            }
            } else {
            Get.snackbar('Error', 'Latitude or Longitude is missing.');
            }
            } else {
            Get.snackbar('Error', 'Arguments or place data is missing.');
            }

          },
          // onPressed: () async {
          //   if (pageDetailController.placeData.value != null) {
          //     var check = await requestLocationPermission();
          //     if (!check!) return;
          //
          //     var place = pageDetailController.placeData.value;
          //     if (place!['Place_latitude'] != null &&
          //         place['Place_longitude'] != null) {
          //       Get.toNamed('map_page', arguments: {
          //         'lat': place['Place_latitude'],
          //         'lon': place['Place_longitude']
          //       });
          //     } else {
          //       Get.snackbar('Error', 'Latitude or Longitude is missing.');
          //     }
          //   } else {
          //     Get.snackbar('Error', 'Arguments or place data is missing.');
          //   }
          // },
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
