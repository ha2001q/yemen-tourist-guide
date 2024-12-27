import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';

import '../../../../core/utils/images.dart';
import '../../../../core/utils/styles.dart';
import '../../controller/profile_controller.dart';
import '../widgets/profile_appbar.dart';
import '../widgets/user_data_widget.dart';

class ProfileScreen extends StatefulWidget {

  ProfileScreen({super.key}) {
    // Call listenToUser in the constructor.

  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  var id;

  @override
  void initState() {
    super.initState();
    UserDataController.loadUser();
    id=UserDataController.userId;
    profileController.listenToUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBarWidget(
        editIcon: Images.editProfileIcon,
        onTapEdit: (){
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context)=>const ProfileUpdateScreen(),));
          // print("onTapEdit");
        },
      ),
      body:id==''?Center(child: Text('You have to login'),): Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            children: [
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Obx(
                    (){


                      return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// image
                        InkWell(
                          onTap: profileController.pickFile,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: profileController.userData['user_image']==null?DecorationImage(
                                image:AssetImage('assets/images/logo_icon.jpg'),
                                fit: BoxFit.cover
                              ):DecorationImage(
                                  image:CachedNetworkImageProvider(profileController.userData['user_image']),
                                  fit: BoxFit.cover
                              ),
                            ),
                            // child: Image.network(profileController.userData['user_image'],fit: BoxFit.cover,),
                          ),
                        ),
                        // Container(
                        //   width: 100,
                        //   height: 100,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(100),
                        //     color: Colors.deepOrange
                        //     // image: DecorationImage(
                        //     //   image:
                        //     //   fit: BoxFit.cover,
                        //     // ),
                        //   ),
                        // ),
                        const SizedBox(height: 5,),
                        /// text user_name
                        Text(profileController.userData['user_name']??"", style: fontMediumBold,),

                        const SizedBox(height: 50),
                        ///name
                        UserDataWidget(
                          userData: profileController.userData['user_name']??"",
                          iconUserData: Images.profileIcon,
                        ),
                        const SizedBox(height: 20,),
                        /// email
                        UserDataWidget(
                            userData: profileController.userData['user_email']??"",
                            iconUserData: Images.smallEmail),
                        const SizedBox(height: 20,),
                        ///password
                        UserDataWidget(
                            userData: "***************  ",
                            iconUserData: Images.lockIcon),

                      ],
                    );
                    }
                  ),

                ),
              ),
            ],
          ),
        )
        //   Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text('Name: ${profileController.userData['user_name'] ?? 'N/A'}'),
        //     Text('Email: ${profileController.userData['user_email'] ?? 'N/A'}'),
        //   ],
        // );
    );
  }
}

