import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';
import 'package:yemen_tourist_guide/customer/add_review/view/review_screen.dart';
import 'package:yemen_tourist_guide/customer/homePage/controller/home_controller.dart';
import 'package:yemen_tourist_guide/customer/place_details/controller/page_detail_controller.dart';
import 'package:yemen_tourist_guide/customer/place_details/data/grant_location.dart';
import 'package:yemen_tourist_guide/customer/place_details/view/widgets/image_slider_widget.dart';

import '../../../core/utils/styles.dart';
import '../../favorite_screen/view/pages/favorite_screen.dart';
import '../../homePage/home_view/widgets/ServicesCard.dart';


class PlaceDetails extends StatefulWidget {
  const PlaceDetails({super.key});

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  // HomeController homeController = Get.find();
  PageDetailController pageDetailController = Get.put(PageDetailController());



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() {
          final placeData = pageDetailController.placeData.value;

          if (placeData == null) {
            return Center(child: CircularProgressIndicator()); // Show a loading indicator
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Place image with back and favorite button
              Stack(
                children: [
                  // Replace this with your image slider widget
                  ImageSliderWidget(images: placeData['place_image']),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
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
                        if (pageDetailController.userId == null ||
                            pageDetailController.userId.isEmpty) {
                          Get.snackbar('Error', 'You have to login first');
                          Get.toNamed('login');
                        } else {
                          pageDetailController.addFavorite(
                            pageDetailController.placeIdd.value,
                            pageDetailController.userId,
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
                          color: pageDetailController.isRed.value
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
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFFE17055),
                          size: 20,
                        ),
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
                    const SizedBox(height: 20),

                    // التقييم والوقت
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        InkWell(
                            onTap: (){
                              Get.toNamed('/add_review',arguments: {'place_id':placeData['place_id']});

                            },
                            child: Text(placeData['rate_avg'])),
                        const SizedBox(width: 20),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/comments',arguments: {'place_id':placeData['place_id']});
                          },
                          child: const Text(
                            'قراءة التعليقات',
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
                    const Text('Services at this place',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    // Services list
                    Obx(() {
                      return Wrap(
                        spacing: 30,
                        runSpacing: 10,
                        children: pageDetailController.homeController.services
                            .map((service) => ServicesCard(
                          onTap: () {},
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
                    }),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
      // زر عرض المسار
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () async {

            if (pageDetailController.placeData != null && pageDetailController.placeData != null) {

              var check = await requestLocationPermission();
              if(!check!){
                return;
              }
              var place = pageDetailController.placeData.value;
              if (place!['Place_latitude'] != null && place!['Place_longitude'] != null) {
                Get.toNamed('map_page', arguments: {
                  'lat': place['Place_latitude'],
                  'lon': place['Place_longitude']
                });
              } else {
                // Handle the case where latitude or longitude is null
                print('Error: Latitude or Longitude is missing.');
                Get.snackbar('Error', 'Latitude or Longitude is missing.');
              }
            } else {
              // Handle the case where arguments or place is null
              print('Error: Arguments or place data is missing.');

              Get.snackbar('Error', 'Arguments or place data is missing.');
            }

            // هنا يمكنك إضافة كود فتح الخريطة أو عرض المسار
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const Googlmap(),
            //   ),
            // );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE17055),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map_outlined),
              SizedBox(width: 10),
              Text(
                'عرض المسار',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, String location, String type) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage('assets/mountain.jpg'), // ضع مسار الصورة الخاصة بك
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 20),
        ],
      ),
    );
  }
}
