
import 'dart:async';
import 'package:get/get.dart';

class SplashController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    // Start the timer for the splash screen duration
    Timer(const Duration(seconds: 3),() {
      // Navigate to the next screen after the timer ends
      Get.offNamed('/root');
    });
  }
}