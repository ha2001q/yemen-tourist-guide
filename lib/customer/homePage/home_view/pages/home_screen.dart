
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/state_manager.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';
import 'package:yemen_tourist_guide/customer/homePage/controller/home_controller.dart';
import 'package:yemen_tourist_guide/customer/homePage/home_view/pages/all_places.dart';
import 'package:yemen_tourist_guide/customer/place_details/controller/page_detail_controller.dart';
import '../../../../core/utils/images.dart';
import '../../../../core/utils/styles.dart';
import '../../controller/Controller.dart';
import '../widgets/PlaceCard.dart';
import '../widgets/ServicesCard.dart';
import '../widgets/banner_section_widget.dart';


class HomePageScreen extends StatelessWidget {
  HomePageScreen({super.key});

  final HomeController homeController = Get.put(HomeController(), permanent: true);
  final UserController userController = Get.put(UserController());
  final controller = CarouselController();


  void animateToSlide(int index) => controller.animateToPage(index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// background
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset('assets/svg/half_circle.svg'),
          ),

          /// page data
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [

                  /// app bar for welcomeing and image user and address
                  const SizedBox(height: 40,),
                  Padding(
                    padding:const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Obx(
                        (){
                          return !homeController.isGuest.value?Container(
                            height: 45.0,
                            width: 45.0,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image:  DecorationImage(
                                image: CachedNetworkImageProvider(userController.userImage.value),
                                fit: BoxFit.cover
                              )
                            ),
                          ):const SizedBox.shrink();
                          },
                        ),

                        Column(
                          children: [
                            Align(alignment: Alignment.bottomRight,child: Text('how_u_day'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)),

                            const SizedBox(height: 7,),
                            Wrap(
                              children: [

                                Obx(() {
                                  // Fetch location data if it's empty
                                  if (homeController.locationData.isEmpty) {
                                    homeController.fetchLocationData();
                                    return const Center(child: SizedBox(height:20,width: 20,child: CircularProgressIndicator(color: Colors.deepOrangeAccent,)));
                                  }
                                  // Display the location data
                                  Map<String, String> data = homeController.locationData;
                                  return
                                    Text(
                                      '${data['city']}, ${data['country']}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFFAF4623), // Fixed color code
                                      ),
                                    );

                                }),

                                SvgPicture.asset('assets/svg/location-icon.svg'),

                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  /// search bar and filter
                  const SizedBox(height: 60,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // Shadow color with transparency
                            spreadRadius: 2, // Spread of the shadow
                            blurRadius: 5,   // Blurring effect
                            offset: const Offset(0, 3), // Position of the shadow (horizontal, vertical)
                          ),
                        ],

                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset('assets/svg/filter-icon.svg'),

                            Wrap(
                              children: [

                                Text('search'.tr, style: const TextStyle(color: Colors.grey),),
                                const SizedBox(width: 10,),
                                SvgPicture.asset('assets/svg/search-icon.svg')
                              ],
                            )

                          ],
                        ),
                      ),
                    ),
                  ),

                  /// selection clips for cities
                  const SizedBox(height: 20,),
                  Obx(
                        () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Static "All" chip
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: ActionChip(
                              label: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  'All', // Static label for "All"
                                  style: TextStyle(
                                    color: homeController.selectedOption.value == 'All' ? Colors.white : Colors.black, // Text color
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              backgroundColor: homeController.selectedOption.value == 'All'
                                  ? const Color(0xFFD05730)
                                  : Colors.white, // Selected color
                              onPressed: () {
                                // Toggle the "All" selection
                                homeController.selectedOption.value = (homeController.selectedOption.value == 'All' ? 'All' : 'All');
                                print('0');
                                homeController.cityId.value = 0;
                                homeController.listenToBanners(0);
                                homeController.listenToPlaces(homeController.cityId.value, homeController.typeId.value);
                              },
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: homeController.selectedOption.value == 'All' ? Colors.deepOrange : Colors.white, // Border color change
                                  width: 0,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15), // Padding inside the chip
                              shadowColor: Colors.black.withOpacity(0.5), // Optional shadow
                              elevation: 5, // Elevation for 3D effect
                            ),
                          ),

                          // Dynamic city chips
                          ...homeController.cities.map((option) {
                            final isSelected = homeController.selectedOption.value == option['city_name'];

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: ActionChip(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    option['city_name'],
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black, // Text color
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                backgroundColor: isSelected
                                    ? const Color(0xFFD05730)
                                    : Colors.white, // Selected color
                                onPressed: () {
                                  homeController.selectedOption.value = isSelected ? null : option['city_name']; // Toggle selection

                                  homeController.cityId.value = option['city_id'];
                                  print(option['city_id'].toString());
                                  homeController.listenToBanners(option['city_id']);
                                  homeController.listenToPlaces(option['city_id'],homeController.typeId.value);

                                },
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: isSelected ? Colors.deepOrange : Colors.white, // Border color change
                                    width: 0,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15), // Padding inside the chip
                                shadowColor: Colors.black.withOpacity(0.5), // Optional shadow
                                elevation: 5, // Elevation for 3D effect
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),


                  /// banner section
                  const SizedBox(height: 30,),
                  Obx(() {
                    if (homeController.bannersd.isEmpty) {
                      return const Center(child: Text('No banners found'));
                    }

                    print(homeController.bannersd[0]['title']);
                    return SizedBox(
                      child: Column(
                        children: [
                          CarouselSlider.builder(
                            carouselController: controller,
                            itemCount: homeController.bannersd.length,
                            itemBuilder: (context, index, realIndex) {
                              return promotionWidget(
                                homeController.bannersd[index]['image'],
                                homeController.bannersd[index]['title'],
                                homeController.bannersd[index]['description'],
                                index,
                              );
                            },
                            options: CarouselOptions(
                              autoPlay: true,
                              enableInfiniteScroll: false,
                              autoPlayAnimationDuration: const Duration(seconds: 2),
                              enlargeCenterPage: true,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),


                  /// place type section
                  const SizedBox(height: 20,),
                   Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    child: Align(alignment: Alignment.bottomLeft,child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Expoler places', style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AllPlacesScreen(),
                                ),
                              );
                            },
                            child: Text('See All', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, color: Colors.deepOrange),)
                        ),
                      ],
                    )),
                  ),
                  const SizedBox(height: 20,),

                  Obx(
                        () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Static "All" chip
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: ActionChip(
                              label: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  'All', // Static label for "All"
                                  style: TextStyle(
                                    color: homeController.selectedOptionTypes.value == 'All' ? Colors.white : Colors.black, // Text color
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              backgroundColor: homeController.selectedOptionTypes.value == 'All'
                                  ? const Color(0xFFD05730)
                                  : Colors.white, // Selected color
                              onPressed: () {
                                // Toggle the "All" selection
                                homeController.selectedOptionTypes.value = (homeController.selectedOptionTypes.value == 'All' ? 'All' : 'All');
                                print('0');
                                homeController.typeId.value = 0;
                                homeController.listenToPlaces(homeController.cityId.value, homeController.typeId.value);
                              },
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: homeController.selectedOptionTypes.value == 'All' ? Colors.deepOrange : Colors.white, // Border color change
                                  width: 0,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15), // Padding inside the chip
                              shadowColor: Colors.black.withOpacity(0.5), // Optional shadow
                              elevation: 5, // Elevation for 3D effect
                            ),
                          ),

                          // Dynamic city chips
                          ...homeController.types.map((option) {
                            final isSelected = homeController.selectedOptionTypes.value == option['type_name'];

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: ActionChip(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    option['type_name'],
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black, // Text color
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                backgroundColor: isSelected
                                    ? const Color(0xFFD05730)
                                    : Colors.white, // Selected color
                                onPressed: () {
                                  homeController.selectedOptionTypes.value = isSelected ? null : option['type_name']; // Toggle selection

                                  homeController.typeId.value = option['type_id'];
                                  print(option['type_id'].toString());
                                  homeController.listenToPlaces(homeController.cityId.value, option['type_id']);
                                },
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: isSelected ? Colors.deepOrange : Colors.white, // Border color change
                                    width: 0,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15), // Padding inside the chip
                                shadowColor: Colors.black.withOpacity(0.5), // Optional shadow
                                elevation: 5, // Elevation for 3D effect
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),


                  /// places data
                  const SizedBox(height: 20,),
                  Obx(
                      (){
                        return  Wrap(
                          spacing: 30, // Space between items horizontally
                          runSpacing: 10, // Space between items vertically
                          children: homeController.places.take(4).map((place) {
                            return PlaceCard(title: place['place_name'], location: place['place_location'], rating: double.parse(place['rate_avg']) ?? 0.0, reviews: int.parse(place['review_num'])??0, imagePath: place['place_image'][0]??'https://tourismteacher.com/wp-content/uploads/2023/10/mosq.jpg',onTap: (){
                              Get.toNamed(
                                '/placeDetailes',
                                arguments: {
                                  'place': place
                                },
                              );
                            },
                              heartFavorite: () {},
                              );
                          }).toList(),
                        );
                      }),


                  /// high rate places
                  const SizedBox(height: 20,),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    child: Align(alignment: Alignment.bottomLeft,child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('love by people', style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                        // Text('See All', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, color: Colors.deepOrange),),
                      ],
                    )),
                  ),
                  Obx(
                        () {
                      // Create a sorted copy of the places list
                      final sortedPlaces = List.from(homeController.places)
                        ..sort((a, b) {
                          final double rateA = double.tryParse(a['rate_avg']) ?? 0.0;
                          final double rateB = double.tryParse(b['rate_avg']) ?? 0.0;
                          return rateB.compareTo(rateA); // Sort in descending order
                        });

                      return Wrap(
                        spacing: 30, // Space between items horizontally
                        runSpacing: 10, // Space between items vertically
                        children: sortedPlaces.map((place) {
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ServicesCard(
                                onTap: (){
                                  Get.toNamed(
                                    '/placeDetailes',
                                    arguments: {
                                      'place': place
                                    },
                                  );

                                },
                              title: place['place_name'],
                              type: place['type_id'].toString(),
                              location: place['place_location'],
                              rating: double.tryParse(place['rate_avg']) ?? 0.0,
                              reviews: int.tryParse(place['review_num']) ?? 0,
                              imageBath: place['place_image'][0]??'https://tourismteacher.com/wp-content/uploads/2023/10/mosq.jpg'
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),



                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget promotionWidget(String image, String title, String description,
      int index) {
    return Container(
      width: 310.0,
      height: 150,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: InkWell(
        onTap: () {
          // widget.onTapBanner(index);
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                width: 93,
                height: 56,
                child: ElevatedButton(
                    onPressed: () {
                      // widget.onTapBanner(index);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFD05730), // Text color
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10)
                        ), // Corner radius
                      ),
                    ),
                    child: const Icon(Icons.arrow_forward)
                ),
              ),
            ),

            Positioned(
              top: 55,
              right: 33,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: 0.54,
                ),
              ),
            ),

            Positioned(
              top: 105,
              right: 9,
              child: Text(
                description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


