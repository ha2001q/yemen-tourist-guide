import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';
import 'package:yemen_tourist_guide/customer/add_review/view/review_screen.dart';
import 'package:yemen_tourist_guide/customer/homePage/controller/home_controller.dart';
import 'package:yemen_tourist_guide/customer/place_details/controller/page_detail_controller.dart';
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
  HomeController homeController = Get.find();
  PageDetailController pageDetailController = Get.put(PageDetailController());

  final UserController _userController = Get.put(UserController());
  var arguments;
  late final List<dynamic> imageList;
  @override
  void initState() {
    super.initState();
    // Access the arguments
    arguments = Get.arguments;
    pageDetailController.placeIdd.value = int.parse(arguments['place']['place_id']);
    homeController.listenToServices(int.parse(arguments['place']['place_id']));
    imageList = arguments['place']['place_image'];
    _userController.loadUser();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SingleChildScrollView(
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المكان مع زر العودة وزر المفضلة
            Stack(
              children: [
                // صورة المكان
                ImageSliderWidget(images: imageList),
                // زر العودة
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
                // زر المفضلة
                Obx(
                  (){ return Positioned(
                    bottom: 20,
                    left: 20,
                    child: InkWell(
                      // onTap:(){
                      //   if(_userController.userId.value == ''){
                      //     print(_userController.userId.value);
                      //     Get.snackbar('Error bro', ' You have to login first');
                      //     Get.toNamed('login');
                      //     return;
                      //   }
                      //   pageDetailController.placeIdd.value = int.parse(arguments['place']['place_id']);
                      //   pageDetailController.addFavorite(int.parse(arguments['place']['place_id']), int.parse(_userController.userId.value));
                      //   },
                      onTap: () {
                        if (_userController.userId.value == '') {
                          Get.snackbar('Error', 'You have to login first');
                          Get.toNamed('login');
                        } else {
                          pageDetailController.addFavorite(
                            int.parse(arguments['place']['place_id']),
                            _userController.userId.value,
                          );
                        }
                      },

                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:  Icon(
                          Icons.favorite,
                          color:  pageDetailController.isRed.value?Color(0xFFE17055):Colors.grey,
                        ),
                      ),
                    ),
                  );}
                ),
              ],
            ),

            // تفاصيل المكان
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الموقع
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFFE17055),
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        arguments['place']['place_location'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // اسم المكان
                  Text(arguments['place']['place_name'],
                    style: fontLargeBold
                  ),

                  const SizedBox(height: 15),

                  // الوصف
                  Text(
                      arguments['place']['place_description'],
                    style: fontMedium
                  ),

                  const SizedBox(height: 20),

                  // التقييم والوقت
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      InkWell(
                        onTap: (){Get.toNamed('/add_review',arguments: {'place_id':arguments['place']['place_id']});

                        },
                          child: Text(arguments['place']['rate_avg'])),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const Star() )
                          // );
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

                  // عنوان الخدمات
                  const Text(
                    'الخدمات في جبل النبي شعيب',
                    style: fontLarge
                  ),

                  const SizedBox(height: 20),

                  // قائمة الخدمات
                  Obx(
                        () {
                      // Create a sorted copy of the places list

                      return Wrap(
                        spacing: 30, // Space between items horizontally
                        runSpacing: 10, // Space between items vertically
                        children: homeController.services.map((service) {
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ServicesCard(
                              onTap: (){},
                                title: service['service_name'],
                                type: service['service_type'],
                                location: service['service_location'],
                                rating: 0.0,
                                reviews: 0,
                                imageBath: service['service_images']??'https://tourismteacher.com/wp-content/uploads/2023/10/mosq.jpg'
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // زر عرض المسار
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {

            if (arguments != null && arguments['place'] != null) {
              var place = arguments['place'];
              if (place['Place_latitude'] != null && place['Place_longitude'] != null) {
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
