import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

              // SettingTemplete(
              //   hamzah: 'notification'.tr,
              //   path: Images.notification,
              //   flag: true,
              //   onTap: ()  {
              //
              //   },
              // ),

              // const SizedBox(
              //   height: 15,
              // ),


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
                          onPressed: (){
                            UserDataController.loadUser();
                            var id = UserDataController.userId;
                            if(id == ''){
                              return;
                            }else{
                              UserDataController.deleteUser();
                              UserDataController.loadUser();
                              Get.back(result: false);
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
