import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/utils/images.dart';
import '../../../core/utils/styles.dart';
import '../../root_screen/root_screen.dart';
import '../../signup_screen/view/signup_screen.dart';
import '../controller/login_controller.dart';
class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});
  // Create an instance of the LoginController
  final LoginController loginController = Get.put(LoginController());


   TextEditingController email = TextEditingController();
   TextEditingController password = TextEditingController();

   final _loginForm = GlobalKey<FormState>();

   @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
            body:
            Stack(
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

                          // SvgPicture.asset(Images.janbiahBack,fit: BoxFit.cover,),
                          Text("Login",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                          SizedBox(height: 35,),
                          Text("Happy to see you again! Please enter your email and",style: TextStyle(color: Colors.black),),
                          Text("password to login to your account.",style: TextStyle(color: Colors.black)),
                          SizedBox(height: 110,),
                          Container(
                            // width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey,
                            ),
                            child:Form(
                              key: _loginForm,
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
                                        hintText:"Email",
                                      ),

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
                                        hintText:"Password",
                                      ),

                                      onSaved: (value) {
                                        password = password;
                                        // = value!;
                                      },
                                      controller:password,
                                      keyboardType: TextInputType.visiblePassword,
                                    ),
                                    const SizedBox(height: 20,),
                                    InkWell(
                                        onTap:() async {
                                          if (_loginForm.currentState!.validate()) {
                                            try{

                                              var email1 = email.text;
                                              var password1 = password.text;

                                              // Call the login method
                                              bool success = await loginController.loginUser(email1, password1);

                                              if (success) {
                                                // Navigate to the next screen if login is successful
                                                Get.snackbar('Login Success', 'Welcome back!');
                                                // You can use Get.to() for navigation
                                                Get.offAndToNamed('/root');
                                              } else {
                                                // Show error message if login fails
                                                Get.snackbar('Login Failed', loginController.errorMessage.value);
                                              }
                                            }catch(onPressed){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context)=>RootScreen()));
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
                                          child: Text("Login",style: fontLarge,textAlign: TextAlign.center,),
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
                              Text("Dont have an acount? ",style: fontMedium,),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                                },
                                child:Text("Sign up",style: TextStyle(color: Color(0xffD87234)),),
                              )
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Continue as ",style: fontMediumBold,),
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context)=>RootScreen()));
                                },
                                child:Text("a Guest",style: TextStyle(color: Color(0xffD87234)),),
                              )
                            ],
                          ),
                          const SizedBox(height: 30.0),


                              // Container(
                              //   height: 1,
                              //   width: double.infinity,
                              //   color: Colors.white,
                              // ),


                          const Text("Sign in with",
                              style: fontSmallBold
                          ),
                          const SizedBox(height: 10.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: (){
                                  // _handleGoogleBtnClick();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 158.50,
                                    height: 70,
                                    padding: const EdgeInsets.only(top: 22, bottom: 23),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Theme.of(context).cardColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).shadowColor.withOpacity(0.2), // Use shadowColor from the theme with opacity
                                          spreadRadius: 2, // Spread radius of the shadow
                                          blurRadius: 4, // Blur radius of the shadow
                                          offset: const Offset(0, 2), // Offset of the shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                width: 25,
                                                height: 25,
                                                child:
                                                SvgPicture.asset(
                                                    Images.googleIcon)
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              InkWell(
                                onTap: (){},
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 158.50,
                                    height: 70,
                                    padding: const EdgeInsets.only(top: 22, bottom: 23),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Theme.of(context).cardColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).shadowColor.withOpacity(0.2), // Use shadowColor from the theme with opacity
                                          spreadRadius: 2, // Spread radius of the shadow
                                          blurRadius: 4, // Blur radius of the shadow
                                          offset: const Offset(0, 2), // Offset of the shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                width: 25,
                                                height: 25,
                                                child:
                                                SvgPicture.asset(
                                                  Images.facebookIcon,
                                                  height: 25,
                                                  width: 25,
                                                )
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                ])
        )


    );
  }
}
