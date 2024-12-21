
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/state_manager.dart';
import 'package:yemen_tourist_guide/customer/homePage/controller/home_controller.dart';
import '../../../../core/utils/images.dart';
import '../../../../core/utils/styles.dart';
import '../../controller/Controller.dart';
import '../widgets/PlaceCard.dart';
import '../widgets/ServicesCard.dart';
import '../widgets/banner_section_widget.dart';


class HomePageScreen extends StatelessWidget {
  HomePageScreen({super.key});

  final HomeController homeController = Get.put(HomeController());

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
                          return homeController.isGuest.value?Container(
                            height: 45.0,
                            width: 45.0,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/logo_image.jpg'),
                                fit: BoxFit.cover
                              )
                            ),
                          ):const SizedBox.shrink();
                          },
                        ),

                        Column(
                          children: [
                            Text('how_u_day'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),

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
                                homeController.selectedOption.value = (homeController.selectedOption.value == 'All' ? null : 'All')!;
                                print('0');
                                homeController.cityId.value = 0;
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


                  const SizedBox(height: 30,),
                  Obx(() {
                    // Check if the loading state is true
                    if (homeController.isLoadingB.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Check if there is any error message
                    if (homeController.errorMessageB.isNotEmpty) {
                      return Center(child: Text('Error: ${homeController.errorMessageB}'));
                    }

                    // Display the banners if they exist
                    return BannerSectionWidget(
                      bannerList: homeController.banners, // Observable banners list
                      onTapBanner: (index) {
                        // Handle banner tap (e.g., navigate to banner detail)
                        // if (kDebugMode) {
                        //   print(homeController.banners[index].id);
                        // }
                      },
                    );
                  }),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// class HomePageScreen extends StatelessWidget {
//    HomePageScreen({super.key});
//   PlacesController placesController = Get.put(PlacesController(), permanent:true);
//
//
//    int _selectedTab = 0;
//    int _selectedCategory = 0;
//
//    final List<String> _cities = ['الكل', 'حجة', 'صنعاء', 'تعز', 'الحديدة','صعدة','عمران'];
//    final List<String> _categories = ['الكل', 'مساجد', 'سدود وشلالات', 'قلاع وحصون', 'معابد'];
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//
//         body:
//           // sharedPref!.setString("id", "1");
//            SingleChildScrollView(
//             child: Column(
//               children: [
//                 Stack(
//                     alignment: Alignment.topRight,
//                     children: [
//                       SvgPicture.asset('assets/svg/half_circle.svg'),
//                       Column(
//                         children: [
//                           // الجزء العلوي مع الصورة الشخصية والترحيب
//
//                           Padding(
//                             padding: const EdgeInsets.all(26.0),
//                             child: Row(
//
//                               children: [
//                                 Container(
//                                   height: 80,
//                                   width: 80,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(50)
//                                   ),
//                                   child:
//                                   CircleAvatar(
//                                     radius: 25, // Adjust the radius as needed
//                                     // backgroundColor: Colors.white,
//                                     child: ClipOval(
//                                       child: Image.asset(Images.logoIcon,fit:BoxFit.cover,
//                                         // CachedNetworkImage(
//                                         //   imageUrl: widget.image,
//                                         //   placeholder: (context, url) => const CircularProgressIndicator(),
//                                         //   errorWidget: (context, url, error) => const Icon(Icons.error),
//
//                                       ),
//                                     ),
//
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       const Text(
//                                           "كيف يومك ",
//                                           style:fontLargeBold
//                                       ),
//                                       const SizedBox(width: 4),
//                                       // Image.asset('assets/svg/half_circle.svg', height: 20),
//                                       // const Text("حمزة!"),
//                                       Row(
//                                         mainAxisAlignment:MainAxisAlignment.end ,
//                                         children: [
//                                           const Text(
//                                               "اليمن، صنعاء",
//                                               style: TextStyle(color: Color(0xFFE17055))
//                                           ),
//
//                                           const Icon(Icons.location_on,
//                                               color: Color(0xFFE17055), size: 16),
//
//                                         ],
//
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 50,),
//
//                           Padding(
//                             padding: const EdgeInsets.all(28.0),
//                             child: TextField(
//                               decoration: InputDecoration(
//                                 hintText: "ابحث",
//                                 prefixIcon: const Icon(Icons.search),
//                                 filled: true,
//                                 fillColor: Colors.grey[200],
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                   borderSide: BorderSide.none,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//
//                           //شريط التنقل بين المدن
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 13.0),
//                             child: SizedBox(
//                               height: 40,
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: _cities.length,
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 4),
//                                     child: ChoiceChip(
//                                       label: Text(_cities[index]),
//                                       selected: _selectedTab == index,
//                                       onSelected: (selected) {
//                                           _selectedTab = index;
//                                       },
//                                       backgroundColor: Colors.grey[200],
//                                       selectedColor: const Color(0xFFE17055),
//                                       labelStyle: TextStyle(
//                                         color: _selectedTab == index
//                                             ? Colors.white
//                                             : Colors.black,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ]
//                 ),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Column(
//                     children: [
//                       Column(
//                           children: [
//                             // صورة جبال خولان
//                             Container(
//                               margin: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 image: const DecorationImage(
//                                   image: AssetImage('assets/images/logo_icon.jpg'),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               height: 200,
//                               child: Stack(
//                                 children: [
//                                   Positioned(
//                                     bottom: 20,
//                                     left: 20,
//                                     child: Row(
//                                       children: [
//                                         const Text(
//                                           "جبال خولان",
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 24,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 8),
//                                         Container(
//                                           padding: const EdgeInsets.all(8),
//                                           decoration: BoxDecoration(
//                                             color: const Color(0xFFE17055),
//                                             borderRadius: BorderRadius.circular(20),
//                                           ),
//                                           child: const Icon(
//                                             Icons.arrow_forward,
//                                             color: Colors.white,
//                                             size: 20,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ]
//                       ),
//
//                       Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text("استكشاف الأماكن", style: fontLargeBold),
//                             const SizedBox(height: 12),
//
//                             // شريط التصنيفات
//                             SizedBox(
//                               height: 40,
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: _categories.length,
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 4),
//                                     child: ChoiceChip(
//                                       label: Text(_categories[index]),
//                                       selected: _selectedCategory == index,
//                                       onSelected: (selected) {
//                                           _selectedCategory = index;
//                                       },
//                                       backgroundColor: Colors.grey[200],
//                                       selectedColor: const Color(0xFFE17055),
//                                       labelStyle: TextStyle(
//                                         color: _selectedCategory == index
//                                             ? Colors.white
//                                             : Colors.black,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//
//                             const SizedBox(height: 16),
//
//                             // بطاقات المواقع
//
//                                Obx((){
//                                  return
//                                 GridView.builder(
//                                  shrinkWrap: true,
//                                     physics: const NeverScrollableScrollPhysics(),
//                                  padding: EdgeInsets.symmetric(horizontal: 10),
//                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
//                                  itemCount: placesController.placesList.length,
//                                 itemBuilder: (context,index){
//                                   final place = placesController.placesList[index];
//                                   return
//                                     Padding(
//                                       padding: const EdgeInsets.all(5.0),
//                                       child: PlaceCard(
//                                               title: place['place_name'],
//                                               location: place['place_location']??' ',
//                                               rating: 4.0,
//                                               reviews: 36,
//                                               imagePath: 'assets/images/logo_icon.jpg',
//                                             ),
//                                     );
//                                 }
//                                 // shrinkWrap: true,
//                                 // physics: const NeverScrollableScrollPhysics(),
//                                 // crossAxisCount: 2,
//                                 // childAspectRatio: 1,
//                                 // mainAxisSpacing: 16,
//                                 // crossAxisSpacing: 16,
//                                 // children: [
//                                 //   PlaceCard(
//                                 //     title: 'حديقة السبعين',
//                                 //     location: 'اليمن، صنعاء',
//                                 //     rating: 4.0,
//                                 //     reviews: 36,
//                                 //     imagePath: 'assets/images/logo_icon.jpg',
//                                 //   ),
//                                 //   PlaceCard(
//                                 //     title: 'جبل النبي شعيب',
//                                 //     location: 'اليمن، صنعاء',
//                                 //     rating: 4.0,
//                                 //     reviews: 36,
//                                 //     imagePath: 'assets/images/logo_icon.jpg',
//                                 //   ),
//                                 // ],
//                                                              );
//
//                                }),
//
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text("معجب بأشخاص", style: fontLargeBold),
//                                 TextButton(
//                                   onPressed: () {},
//                                   child: const Text("عرض الكل",
//                                     style: TextStyle(
//                                       color: Color(0xFFE17055),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             ServicesCard(
//                               title: 'مطعم الملكي',
//                               type: 'مطاعم',
//                               location: 'اليمن، صنعاء',
//                               rating: 4.0,
//                               reviews: 36,
//                               imageBath: 'assets/images/logo_icon.jpg',
//
//                               // '\$400/night',
//                             ),
//                             const SizedBox(height: 16),
//                             ServicesCard(
//                               title: 'مقهى حراز',
//                               type: 'Park',
//                               location: 'اليمن، صنعاء',
//                               rating: 4.0,
//                               reviews: 36,
//                               imageBath: 'assets/images/logo_icon.jpg',
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//
//           //   ListView.builder(
//           //
//           //   itemCount: placesController.placesList.length,
//           //   itemBuilder: (context, index) {
//           //     final place = placesController.placesList[index];
//           //     return ListTile(
//           //
//           //       title: Text(place['place_name'] ?? 'Unnamed Place'),
//           //       subtitle: Text(place['place_description'] ?? 'No description'),
//           //     );
//           //   },
//           // );
//
//       ),
//     );
//   }
// }
