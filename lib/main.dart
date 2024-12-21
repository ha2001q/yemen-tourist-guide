import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';
import 'package:yemen_tourist_guide/core/locale/my_locale.dart';
import 'package:yemen_tourist_guide/customer/homePage/controller/home_controller.dart';
import 'package:yemen_tourist_guide/customer/profile_screen/controller/profile_controller.dart';
import 'package:yemen_tourist_guide/customer/profile_screen/view/pages/profile_screen.dart';

import 'customer/homePage/home_view/pages/home_screen.dart';

SharedPreferences? sharedPref;

Future<void> main() async {
  /// 1. for Localization and Languages
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  /// this to make battery, notification icons fixable changes colors above the appbar.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),);

  UserController userController = Get.put(UserController(), permanent: true);

  // userController.setUser('1', 'dheya', 'dmmmmmm');
  // userController.deleteUser();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      locale: Get.deviceLocale,
      translations: MyLocal(),
      initialRoute: "/profile",
      getPages: [
        GetPage(
            name: "/first",
            page: ()=>HomePageScreen(),
            binding: BindingsBuilder(()=>Get.put(HomeController()))
        ),
        GetPage(
            name: "/home-page",
            page: ()=>HomePageScreen(),
            binding: BindingsBuilder(()=>Get.put(HomeController()))
        ),
        GetPage(
            name: "/profile",
            page: ()=>ProfileScreen(),
            binding: BindingsBuilder(()=>Get.put(ProfileController()))
        ),
      ],
    );
  }
}




