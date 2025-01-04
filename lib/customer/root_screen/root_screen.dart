import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import '../favorite_screen/view/pages/favorite_screen.dart';
import '../homePage/home_view/pages/home_screen.dart';
import '../profile_screen/view/pages/profile_screen.dart';
import '../setting_screen/view/setting_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();


  }
  // UserController userController =Get.put(UserController());
  int bottomNavIndex = 0;

  List<Widget> pages =  [
    HomePageScreen(),
    FavoriteScreen(),
    ProfileScreen(),
    SettingScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: bottomNavIndex != 0 && bottomNavIndex != 2 && bottomNavIndex != 3
      //     ? buildAppBar()
      //     : null,
      body: pages[bottomNavIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey,
            hoverColor: Colors.grey,
            haptic: true,
            tabBorderRadius: 15,
            // tabActiveBorder: Border.all(color: Colors.grey, width: 0),
            // tabBorder: Border.all(color: Colors.grey, width: 1),
            // tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)],
            curve: Curves.easeOutExpo,
            duration: const Duration(milliseconds: 900),
            gap: 8,
            onTabChange: (index) => setState(() => bottomNavIndex = index),//change the pages
            selectedIndex: bottomNavIndex,
            color: Colors.grey[800],
            activeColor: Colors.deepOrangeAccent,
            iconSize: 24,
            tabBackgroundColor: Colors.purple.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            tabs:  [
              GButton(icon: LineIcons.home, text: 'home'.tr),
              GButton(icon: LineIcons.heart, text: 'favorite'.tr),
              GButton(icon: LineIcons.user, text: 'profile'.tr),
              GButton(icon: LineIcons.cog, text: 'Setting'.tr),
            ],
          ),
        ),
      ),
    );
  }
}
