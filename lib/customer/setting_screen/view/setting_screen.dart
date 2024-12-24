import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/customer/setting_screen/view/widget/setting_widget.dart';

import '../../../core/utils/images.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  get userId => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:AppBarWidget(
      //   title: 'setting_title',
      //   onTap: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder:
      //           (context)=>const RootScreen(),));
      //   },
      // ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70,
              ),

              SettingTemplete(
                hamzah: "Profile",
                path: Images.profileIcon,
                flag: true,
                onTap: () {
                  // if(checkIfLogIn()) {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder:
                  //           (context) => const ProfileScreen())
                  //   );
                  // } else{
                  //   showLoginPopup(context);
                  // }
                },
              ),

              const SizedBox(
                height: 15,
              ),

              // SettingTemplete(
              //   hamzah:'add_alarm_notification',
              //   path: Images.guideLines,
              //   flag: false,
              //   onTap: (){
              //     // Navigator.push(
              //     //     context,
              //     //     MaterialPageRoute(builder: (context)=> const AddAlarmScreen())
              //     // );
              //   },
              // ),

              const SizedBox(
                height: 15,
              ),

              // SettingTemplete(
              //   hamzah:'owner_page',
              //   path: Images.userPage,
              //   flag: false,
              //   onTap: (){
              //     // if(userType == AppConstants.promoter || userType == AppConstants.agent || userType == AppConstants.admin|| userType == AppConstants.owner){
              //     //   Navigator.pushReplacement(
              //     //       context,
              //     //       MaterialPageRoute(builder: (context)=> const OwnerRootScreen())
              //     //   );
              //     }
              //     // else{
              //       // Navigator.push(
              //       //     context,
              //       //     MaterialPageRoute(builder: (context)=> const ModificationScreen())
              //       // );
              //     // }
              //
              //   // },
              // ),

              const SizedBox(
                height: 15,
              ),

              SettingTemplete(
                hamzah: 'Language',
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
                hamzah: 'notification',
                path: Images.notification,
                flag: true,
                onTap: () async {
                  // final token = await SharedPrefManager.getData(AppConstants.token);
                  // if(token != null){
                  //   // Navigator.push(
                  //   //     context,
                  //   //     MaterialPageRoute(builder: (context)=> NotificationScreen(token: token))
                  //   // );
                  // }
                },
              ),

              const SizedBox(
                height: 15,
              ),

              // SettingTemplete(
              //   hamzah:'customer_service',
              //   path: Images.notification,
              //   flag: false,
              //   onTap: (){
              //     // Navigator.push(
              //     //     context,
              //     //     MaterialPageRoute(builder: (context)=> const FeedbackScreen())
              //     // );
              //   },
              // ),

              const SizedBox(
                height: 30.0,
              ),

              Text("information",
                  style: const TextStyle(
                    color: Colors.grey,
                  )),

              const SizedBox(
                height: 15,
              ),

              SettingTemplete(
                hamzah: 'version',
                path: Images.version,
                flag: true,
                onTap: () {},
              ),

              const SizedBox(
                height: 15,
              ),

              SettingTemplete(
                hamzah: 'Terms of service',
                path: Images.termsOfService,
                flag: true,
                onTap: () {},
              ),

              const SizedBox(
                height: 15,
              ),

              SettingTemplete(
                hamzah: 'Privacy Policy',
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
                      title: 'Confirm Logout',
                      middleText: 'Are you sure you want to logout?',
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text('Logout'),
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
                  child: Text("logout",
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
                  const Text(
                    'Select Language',
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
                    title: const Text('English'),
                    onTap: () {
                      Get.updateLocale(const Locale('en', 'US'));
                      Get.back();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.language, color: Colors.green),
                    title: const Text('Arabic'),
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
