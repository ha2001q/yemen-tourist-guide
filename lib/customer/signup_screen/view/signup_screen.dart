import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/core/method/SRValidator.dart';
import 'package:yemen_tourist_guide/customer/signup_screen/controller/signup_controller.dart';
import 'package:yemen_tourist_guide/customer/signup_screen/view/verification_email.dart';
import '../../../core/utils/images.dart';
import '../../../core/utils/styles.dart';
import '../../login_screen/view/login_screen.dart';

final _SignUpForm = GlobalKey<FormState>();

class SignupScreen extends StatefulWidget {
   const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
                SizedBox(
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
                        const Text('Sign up',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                        const SizedBox(height: 35,),
                        Text('welcome1'.tr,style: const TextStyle(color: Colors.brown),),
                        Text('welcome2'.tr,style: const TextStyle(color: Colors.brown),),
                        const SizedBox(height: 110,),
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
                                  const SizedBox(height: 15,),
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
                                  const SizedBox(height: 15,),
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'enter password'.tr;
                                      }
                                    //   if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value!)) {
                                    //     return "just_letter";
                                    //   }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      password = password;
                                      // = value!;
                                    },
                                    controller:password,
                                    keyboardType: TextInputType.visiblePassword,
                                  ),
                                  const SizedBox(height: 50,),
                                  InkWell(
                                      onTap:() async {
                                        String? token = await FirebaseMessaging.instance.getToken();
                                        if (_SignUpForm.currentState!.validate()) {
                                          try{
                                           var name1 = name.text ;
                                           var email1 = email.text ;
                                           var password1 = password.text ;
                                           // Call the login method
                                           var success = await signupController.signupUser(name1, email1, password1,token!);

                                           if (success) {
                                             // After calling signupUser and sending verification email
                                             Get.to(() => VerifyEmailScreen(email: email1,image: '',userName: name1,password: password1,));
                                             // Get.offAndToNamed('/root');
                                           } else {
                                             // Show error message if login fails
                                             Get.snackbar('Sign up Failed', signupController.errorMessage.value);
                                           }
                                          }catch(onPressed){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context)=>LoginScreen()));
                                          }
                                        }
                                      },
                                      child: Obx(
                                        ()=> Container(
                                          height: 45,
                                          width: 280,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: const Color(0xffDE7254),
                                          ),
                                          child: signupController.isLoading.value?const Center(child: CircularProgressIndicator(color: Colors.white,)):Text('Sign up'.tr,style: fontLarge,textAlign: TextAlign.center,),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('already have'.tr,style: fontMedium,),
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                              },
                              child:Text('login'.tr,style: const TextStyle(color: Color(0xffD87234)),),
                            )
                          ],
                        ),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
              ]),
        ));
  }
}
