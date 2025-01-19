import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../core/utils/images.dart';

class AddFavorite extends StatefulWidget {
  const AddFavorite({super.key});

  @override
  State<AddFavorite> createState() => _AddFavoriteState();
}

class _AddFavoriteState extends State<AddFavorite> {
  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                Get.toNamed('/search');
              },
              child: SvgPicture.asset(Images.addComment,
             width: 70,
             height: 70,
           ),
            ),
            const SizedBox(height: 16),
            Text('text_in_empty_favorite_page'.tr,
              style: const TextStyle(color: Color(0xffD87234),fontSize: 25),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text('text_in_empty_favorite_page2'.tr,
                style: fontMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],        ),
      );
  }
}
