// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/utils.dart';
//
// import '../../../../core/utils/styles.dart';
//
//
//
// class AppBarSearch extends StatelessWidget implements PreferredSizeWidget{
//   const AppBarSearch({super.key,   required this.onTapBack});
//   final VoidCallback onTapBack;
//   // final VoidCallback onPressed;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text('search'.tr,style: fontLargeBold,),
//       centerTitle: true,
//
//       leading:IconButton(
//         style: IconButton.styleFrom(
//         backgroundColor:Theme.of(context).cardColor,
//         ),
//         icon: const Icon(Icons.arrow_back_ios_new_outlined,size: 15,),
//       onPressed: onTapBack,
//       ) ,
//
//       // actions: [
//       // IconButton(
//       //   onPressed: onPressed,
//       //   icon: SvgPicture.asset('assets/svg/search-icon.svg'),
//       // )
//       // ],
//     );
//   }
//
//   @override
//   // TODO: implement preferredSize
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
//
//
//
