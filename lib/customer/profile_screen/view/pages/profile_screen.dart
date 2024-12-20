import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/images.dart';
import '../../../../core/utils/styles.dart';
import '../../controller/profile_controller.dart';
import '../widgets/profile_appbar.dart';
import '../widgets/user_data_widget.dart';

class ProfileScreen extends StatelessWidget {
  final int userId = 1; // User ID to fetch.
  final ProfileController profileController = Get.put(ProfileController());

  ProfileScreen({super.key}) {
    // Call listenToUser in the constructor.
    profileController.listenToUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBarWidget(
        editIcon: Images.editProfileIcon,
        onTapBack: (){

          Navigator.pop(context);
          // print("onTapback");
        },
        onTapEdit: (){

          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context)=>const ProfileUpdateScreen(),));
          // print("onTapEdit");
        },
      ),
      body: Obx(() {
        // Check if data is available.
        if (profileController.userData.isEmpty) {
          return Center(child: Text('No data available for user ID: $userId'));
        }

        // Display user data.
        return Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            children: [
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// image
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.deepOrange
                          // image: DecorationImage(
                          //   image:
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      /// text user_name
                      Text(profileController.userData['user_name'], style: fontMediumBold,),

                      const SizedBox(height: 50),
                      ///name
                      UserDataWidget(
                        userData: profileController.userData['user_name'],
                        iconUserData: Images.profileIcon,
                      ),
                      const SizedBox(height: 20,),
                      /// email
                      UserDataWidget(
                          userData: profileController.userData['user_email'],
                          iconUserData: Images.smallEmail),
                      const SizedBox(height: 20,),
                      ///password
                      UserDataWidget(
                          userData: "***************  ",
                          iconUserData: Images.lockIcon),

                    ],
                  ),

                ),
              ),
            ],
          ),
        );
        //   Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text('Name: ${profileController.userData['user_name'] ?? 'N/A'}'),
        //     Text('Email: ${profileController.userData['user_email'] ?? 'N/A'}'),
        //   ],
        // );
      }),
    );
  }
}

