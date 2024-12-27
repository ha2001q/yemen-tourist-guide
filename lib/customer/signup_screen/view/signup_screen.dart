import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:yemen_tourist_guide/core/method/SRValidator.dart';
import 'package:yemen_tourist_guide/customer/signup_screen/controller/signup_controller.dart';

import '../../../core/utils/images.dart';
import '../../../core/utils/styles.dart';
import '../../login_screen/view/login_screen.dart';

final _SignUpForm = GlobalKey<FormState>();

class SignupScreen extends StatelessWidget {
   SignupScreen({super.key});

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Stack(
              children: [
                Container(
                    width: double.infinity,
                    height: double.infinity,
                    child:SvgPicture.asset(Images.janbiahBack,fit: BoxFit.fill,)
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 150,left: 10,right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Sign up',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                        SizedBox(height: 35,),
                        Text('welcome'.tr,style: TextStyle(color: Colors.black),),
                        SizedBox(height: 110,),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey,
                          ),
                          child:Form(
                            key: _SignUpForm,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Theme.of(context).cardColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText:'Full Name'.tr,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'enter Full name'.tr;
                                      }
                                      if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value!)) {
                                        return 'just_letter'.tr.camelCase;
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      name = name;
                                      // = value!;
                                    },
                                    controller:name,
                                    keyboardType: TextInputType.name,
                                  ),
                                  SizedBox(height: 15,),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Theme.of(context).cardColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText:'Email'.tr,
                                    ),
                                    validator: SRValidator.validateEmail,
                                    onSaved: (value) {
                                      email = email;
                                      // = value!;
                                    },
                                    controller:email,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  SizedBox(height: 15,),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Theme.of(context).cardColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText:'Password'.tr,
                                    ),
                                    // validator: (value) {
                                    //   if (value == null || value.isEmpty) {
                                    //     return "enter password";
                                    //   }
                                    //   if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value!)) {
                                    //     return "just_letter";
                                    //   }
                                    //   return null;
                                    // },
                                    onSaved: (value) {
                                      password = password;
                                      // = value!;
                                    },
                                    controller:password,
                                    keyboardType: TextInputType.visiblePassword,
                                  ),
                                  SizedBox(height: 50,),
                                  InkWell(
                                      onTap:() async {
                                        if (_SignUpForm.currentState!.validate()) {
                                          try{
                                           var name1 = name.text ;
                                           var email1 = email.text ;
                                           var password1 = password.text ;
                                           // Call the login method
                                           bool success = await signupController.signupUser(name1, email1, password1);

                                           if (success) {
                                             // Navigate to the next screen if login is successful
                                             Get.snackbar('Login Success', 'Welcome back!');
                                             // You can use Get.to() for navigation
                                             Get.offAndToNamed('/root');
                                           } else {
                                             // Show error message if login fails
                                             Get.snackbar('Login Failed', signupController.errorMessage.value);
                                           }
                                          }catch(onPressed){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context)=>LoginScreen()));
                                          }
                                        }
                                      },
                                      child: Container(
                                        height: 45,
                                        width: 280,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Color(0xffDE7254),
                                        ),
                                        child: Text('Sign up'.tr,style: fontLarge,textAlign: TextAlign.center,),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('already have'.tr,style: fontMedium,),
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                              },
                              child:Text('login'.tr,style: TextStyle(color: Color(0xffD87234)),),
                            )
                          ],
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
              ]),
        ));
  }
}
