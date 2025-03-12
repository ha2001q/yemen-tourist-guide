import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yemen_tourist_guide/core/utils/styles.dart';
import 'package:yemen_tourist_guide/customer/setting_screen/view/widget/setting_widget.dart';

import '../../../core/common_controller/user_data.dart';
import '../../../core/utils/images.dart';

class SettingScreen extends StatelessWidget {
   SettingScreen({super.key});
  // UserController userController = Get.put(UserController());

  get userId => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Setting'.tr,style: fontLargeBold,),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),

              SettingTemplete(
                hamzah: 'profile'.tr,
                path: Images.profileIcon,
                flag: true,
                onTap: () {
                  Get.toNamed('/profile');
                  }
              ),

              const SizedBox(
                height: 15,
              ),


              const SizedBox(
                height: 15,
              ),



              const SizedBox(
                height: 15,
              ),

              SettingTemplete(
                hamzah: 'Language'.tr,
                path: Images.language,
                flag: true,
                onTap: () {
                  _showLanguageBottomSheet(context);
                },
              ),

              const SizedBox(
                height: 15,
              ),

              SettingTemplete(
                hamzah: 'notification'.tr,
                path: Images.notification,
                flag: true,
                onTap: ()  {
                  Get.toNamed('/notification');
                },
              ),

              const SizedBox(
                height: 15,
              ),


              const SizedBox(
                height: 45.0,
              ),

              Text('information'.tr,
                  style: const TextStyle(
                    color: Colors.grey,
                  )),

              const SizedBox(
                height: 15,
              ),

              SettingTemplete(
                hamzah: 'version'.tr,
                path: Images.version,
                flag: true,
                onTap: () {},
              ),

              const SizedBox(
                height: 15,
              ),

              SettingTemplete(
                hamzah: 'Terms of service'.tr,
                path: Images.termsOfService,
                flag: true,
                onTap: () {},
              ),

              const SizedBox(
                height: 15,
              ),

              SettingTemplete(
                hamzah: 'Privacy Policy'.tr,
                path: Images.privacyPolicy,
                flag: true,
                onTap: () {},
              ),

              const SizedBox(
                height: 15.0,
              ),

              InkWell(
                  onTap: () async {
                    bool confirmLogout = await Get.defaultDialog(
                      title: 'Confirm Logout'.tr,
                      middleText: 'Are you sure you want to logout?'.tr,
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child:  Text('Cancel'.tr),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Call the Google logout method
                            try {
                              await GoogleSignIn().signOut(); // Google SignOut
                              await FirebaseAuth.instance.signOut(); // Firebase SignOut

                              // Optionally, delete user data here (if needed)
                              UserDataController.loadUser();
                              var id = UserDataController.userId;
                              if (id == '') {
                                return;
                              } else {
                                // If there's a valid user, delete and reload data
                                UserDataController.deleteUser();
                                UserDataController.loadUser();

                                // Optionally, use Get.back to go back with a result
                                Get.back(result: false);

                                // Show a snackbar or toast as feedback
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Logged out successfully!")),
                                );
                              }
                            } catch (e) {
                              // Handle any errors during logout
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Logout failed: $e")),
                              );
                            }
                          },
                          child:  Text('Logout'.tr),
                        ),
                      ],
                    );

                    if (confirmLogout ?? false) {
                      // Perform logout action
                      // await AuthRepository.logout();
                      // // Navigate to login screen or root screen
                      // Get.offAll(() => const RootScreen());
                    }
                  },
                  child: Text('Logout'.tr,
                      style:
                          const TextStyle(fontSize: 19, color: Colors.blue))),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                   Text(
                    'Select Language'.tr,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                  ListTile(
                    leading: const Icon(Icons.language, color: Colors.blue),
                    title:  Text('English'.tr),
                    onTap: () {
                      Get.updateLocale(const Locale('en', 'US'));
                      Get.back();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.language, color: Colors.green),
                    title:  Text('Arabic'.tr),
                    onTap: () {
                      Get.updateLocale(const Locale('ar', 'SA'));
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
