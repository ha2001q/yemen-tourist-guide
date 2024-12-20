import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/styles.dart';

class ProfileAppBarWidget extends StatelessWidget  implements PreferredSizeWidget{
  const ProfileAppBarWidget({super.key, required this.onTapBack, required this.onTapEdit, required this.editIcon});
  // final String title;
  final VoidCallback onTapBack;
  final VoidCallback onTapEdit;
  final String editIcon;



  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AppBar(
        title: Text('profile'.tr,style: fontLargeBold,),
        centerTitle: true,

        leading: IconButton(
            style: IconButton.styleFrom(
              backgroundColor:const Color(0xffF5F4F8),
            ),
            icon: const Icon(Icons.arrow_back_ios_new_outlined,),
            onPressed: onTapBack
        ),
        actions: [
          IconButton(
              style: IconButton.styleFrom(
                backgroundColor:Theme.of(context).cardColor,
              ),
              icon: SvgPicture.asset(editIcon, width: 41.0, height: 41.0,),
              onPressed: onTapEdit
          ),
        ],

      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);}
