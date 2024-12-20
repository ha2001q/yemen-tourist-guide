
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../../../../core/utils/images.dart';
import '../../../../core/utils/styles.dart';
import '../../controller/Controller.dart';
import '../widgets/PlaceCard.dart';
import '../widgets/ServicesCard.dart';

class HomePageScreen extends StatelessWidget {
   HomePageScreen({super.key});
  PlacesController placesController = Get.put(PlacesController(), permanent:true);


   int _selectedTab = 0;
   int _selectedCategory = 0;

   final List<String> _cities = ['الكل', 'حجة', 'صنعاء', 'تعز', 'الحديدة','صعدة','عمران'];
   final List<String> _categories = ['الكل', 'مساجد', 'سدود وشلالات', 'قلاع وحصون', 'معابد'];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body:
          // sharedPref!.setString("id", "1");
           SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                    alignment: Alignment.topRight,
                    children: [
                      SvgPicture.asset('assets/svg/half_circle.svg'),
                      Column(
                        children: [
                          // الجزء العلوي مع الصورة الشخصية والترحيب

                          Padding(
                            padding: const EdgeInsets.all(26.0),
                            child: Row(

                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  child:
                                  CircleAvatar(
                                    radius: 25, // Adjust the radius as needed
                                    // backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: Image.asset(Images.logoIcon,fit:BoxFit.cover,
                                        // CachedNetworkImage(
                                        //   imageUrl: widget.image,
                                        //   placeholder: (context, url) => const CircularProgressIndicator(),
                                        //   errorWidget: (context, url, error) => const Icon(Icons.error),

                                      ),
                                    ),

                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                          "كيف يومك ",
                                          style:fontLargeBold
                                      ),
                                      const SizedBox(width: 4),
                                      // Image.asset('assets/svg/half_circle.svg', height: 20),
                                      // const Text("حمزة!"),
                                      Row(
                                        mainAxisAlignment:MainAxisAlignment.end ,
                                        children: [
                                          const Text(
                                              "اليمن، صنعاء",
                                              style: TextStyle(color: Color(0xFFE17055))
                                          ),

                                          const Icon(Icons.location_on,
                                              color: Color(0xFFE17055), size: 16),

                                        ],

                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 50,),

                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "ابحث",
                                prefixIcon: const Icon(Icons.search),
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          //شريط التنقل بين المدن
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13.0),
                            child: SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _cities.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: ChoiceChip(
                                      label: Text(_cities[index]),
                                      selected: _selectedTab == index,
                                      onSelected: (selected) {
                                          _selectedTab = index;
                                      },
                                      backgroundColor: Colors.grey[200],
                                      selectedColor: const Color(0xFFE17055),
                                      labelStyle: TextStyle(
                                        color: _selectedTab == index
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Column(
                          children: [
                            // صورة جبال خولان
                            Container(
                              margin: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/logo_icon.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: 200,
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child: Row(
                                      children: [
                                        const Text(
                                          "جبال خولان",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE17055),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("استكشاف الأماكن", style: fontLargeBold),
                            const SizedBox(height: 12),

                            // شريط التصنيفات
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _categories.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: ChoiceChip(
                                      label: Text(_categories[index]),
                                      selected: _selectedCategory == index,
                                      onSelected: (selected) {
                                          _selectedCategory = index;
                                      },
                                      backgroundColor: Colors.grey[200],
                                      selectedColor: const Color(0xFFE17055),
                                      labelStyle: TextStyle(
                                        color: _selectedCategory == index
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            // بطاقات المواقع

                               Obx((){
                                 return
                                GridView.builder(
                                 shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                 padding: EdgeInsets.symmetric(horizontal: 10),
                                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
                                 itemCount: placesController.placesList.length,
                                itemBuilder: (context,index){
                                  final place = placesController.placesList[index];
                                  return
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: PlaceCard(
                                              title: place['place_name'],
                                              location: place['place_location']??' ',
                                              rating: 4.0,
                                              reviews: 36,
                                              imagePath: 'assets/images/logo_icon.jpg',
                                            ),
                                    );
                                }
                                // shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(),
                                // crossAxisCount: 2,
                                // childAspectRatio: 1,
                                // mainAxisSpacing: 16,
                                // crossAxisSpacing: 16,
                                // children: [
                                //   PlaceCard(
                                //     title: 'حديقة السبعين',
                                //     location: 'اليمن، صنعاء',
                                //     rating: 4.0,
                                //     reviews: 36,
                                //     imagePath: 'assets/images/logo_icon.jpg',
                                //   ),
                                //   PlaceCard(
                                //     title: 'جبل النبي شعيب',
                                //     location: 'اليمن، صنعاء',
                                //     rating: 4.0,
                                //     reviews: 36,
                                //     imagePath: 'assets/images/logo_icon.jpg',
                                //   ),
                                // ],
                                                             );

                               }),

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("معجب بأشخاص", style: fontLargeBold),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text("عرض الكل",
                                    style: TextStyle(
                                      color: Color(0xFFE17055),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ServicesCard(
                              title: 'مطعم الملكي',
                              type: 'مطاعم',
                              location: 'اليمن، صنعاء',
                              rating: 4.0,
                              reviews: 36,
                              imageBath: 'assets/images/logo_icon.jpg',

                              // '\$400/night',
                            ),
                            const SizedBox(height: 16),
                            ServicesCard(
                              title: 'مقهى حراز',
                              type: 'Park',
                              location: 'اليمن، صنعاء',
                              rating: 4.0,
                              reviews: 36,
                              imageBath: 'assets/images/logo_icon.jpg',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          //   ListView.builder(
          //
          //   itemCount: placesController.placesList.length,
          //   itemBuilder: (context, index) {
          //     final place = placesController.placesList[index];
          //     return ListTile(
          //
          //       title: Text(place['place_name'] ?? 'Unnamed Place'),
          //       subtitle: Text(place['place_description'] ?? 'No description'),
          //     );
          //   },
          // );

      ),
    );
  }
}
