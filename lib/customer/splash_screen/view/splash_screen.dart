import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../core/utils/images.dart';
import '../controller/Splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final SplashController controller = Get.put(SplashController());


  @override
  Widget build(BuildContext context) {
    return Stack(
          children:[
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SvgPicture.asset(Images.splash,fit: BoxFit.fill,),
            ),
             Center(
                child:  Text('hello'.tr,
                  style: const TextStyle(fontSize: 35,color: Color(0xff61462E),fontWeight: FontWeight.bold,),
                  textAlign: TextAlign.center,),
                )
          ]
      );
  }
}
