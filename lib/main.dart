import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemen_tourist_guide/core/locale/my_locale.dart';
import 'package:yemen_tourist_guide/customer/homePage/controller/home_controller.dart';
import 'package:yemen_tourist_guide/customer/splash_screen/controller/Splash_controller.dart';

import 'customer/homePage/home_view/pages/home_screen.dart';
import 'customer/splash_screen/view/splash_screen.dart';

SharedPreferences? sharedPref;

Future<void> main() async {
  /// 1. for Localization and Languages
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
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
      initialRoute: "/splash",
      getPages: [
        GetPage(
            name: "/splash",
            page: ()=>SplashScreen(),
            binding: BindingsBuilder(()=>Get.put(SplashController()))
        ),
        GetPage(
            name: "/home",
            page: ()=>HomePageScreen(),
            binding: BindingsBuilder(()=>Get.put(HomeController()))
        ),

      ],
    );
  }
}




