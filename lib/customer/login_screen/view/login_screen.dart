import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/core/method/SRValidator.dart';
import '../../../core/utils/images.dart';
import '../../../core/utils/styles.dart';
import '../../root_screen/root_screen.dart';
import '../../signup_screen/view/signup_screen.dart';
import '../controller/login_controller.dart';


final _loginForm = GlobalKey<FormState>();
class LoginScreen extends StatefulWidget{
   LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Create an instance of the LoginController
  bool _isObscure = true;
  final LoginController loginController = Get.put(LoginController());

   TextEditingController email = TextEditingController();

   TextEditingController password = TextEditingController();

   Future<UserCredential?> loginWithFacebook() async {
     try {
       // Trigger the Facebook login process
       final LoginResult loginResult = await FacebookAuth.instance.login();

       // Check the status of the login result
       if (loginResult.status == LoginStatus.success) {
         // Retrieve the Facebook access token
         final AccessToken accessToken = loginResult.accessToken!;

         // Create an OAuth credential using the access token
         final OAuthCredential oAuthCredential =
         FacebookAuthProvider.credential(accessToken.tokenString);

         // Sign in to Firebase with the Facebook OAuth credential
         return await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
       } else if (loginResult.status == LoginStatus.cancelled) {
         // Handle login cancellation
         debugPrint('Facebook login cancelled by user.');
         return null;
       } else {
         // Handle login error
         debugPrint('Facebook login failed: ${loginResult.message}');
         return null;
       }
     } catch (e) {
       // Handle any exceptions that occur during the login process
       debugPrint('Error during Facebook login: $e');
       return null;
     }
   }

   @override
  Widget build(BuildContext context) {


    return SafeArea(
        child: Scaffold(
            body:
            Stack(
                children: [
                  SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child:SvgPicture.asset(Images.janbiahBack,fit: BoxFit.fill,)
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 120,left: 10,right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          // SvgPicture.asset(Images.janbiahBack,fit: BoxFit.cover,),
                          Text('login'.tr,style: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                          const SizedBox(height: 35,),
                          Text('welcome1'.tr,style: const TextStyle(color: Colors.blueGrey),),
                          Text('welcome2'.tr,style: const TextStyle(color: Colors.blueGrey),),
                          const SizedBox(height: 110,),
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
                                        hintText:'Email'.tr,
                                      ),

                                      onSaved: (value) {
                                        email = email;
                                        // = value!;
                                      },
                                      validator: SRValidator.validateEmail,
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
                                        hintText: 'Password'.tr,
                                        suffixIcon: IconButton(
                                          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              _isObscure = !_isObscure;
                                            });
                                          },
                                        ),
                                      ),
                                      obscureText: _isObscure,
                                      onSaved: (value) {
                                        password = password;
                                      },
                                      controller: password,
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
                                                  MaterialPageRoute(builder: (context)=>const RootScreen()));
                                            }
                                          }
                                        },
                                        child: Obx(
                                            (){
                                              return Container(
                                                height: 45,
                                                width: 280,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: const Color(0xffDE7254),
                                                ),
                                                child: loginController.isLoading.value?const Center(child: CircularProgressIndicator(color: Colors.white,)):Text('login'.tr,style: fontLarge,textAlign: TextAlign.center,),
                                              );
                                            }
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
                              Text('dontHave'.tr,style: fontMedium,),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                                },
                                child:Text('Sign up'.tr,style: const TextStyle(color: Color(0xffD87234)),),
                              )
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Continue as '.tr,style: fontMediumBold,),
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context)=>const RootScreen()));
                                },
                                child:Text('a Guest'.tr,style: const TextStyle(color: Color(0xffD87234)),),
                              )
                            ],
                          ),
                          const SizedBox(height: 20.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.blue,
                                  indent: 1,
                                  endIndent: 10,
                                ),
                              ),
                              Text(
                                'Sign in with'.tr,
                              ),
                              const Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.blue,
                                  indent: 10,
                                  endIndent: 1,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: (){
                                  loginController.signUpWithGoogle(context);
                                  // _handleGoogleBtnClick();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 330.50,
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

                              // InkWell(
                              //   onTap: ()async{
                              //     final userCredential = await loginWithFacebook();
                              //     if (userCredential != null) {
                              //       debugPrint('User signed in: ${userCredential.user?.email}');
                              //     } else {
                              //       debugPrint('Facebook login unsuccessful.');
                              //     }
                              //
                              //   },
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Container(
                              //       width: 158.50,
                              //       height: 70,
                              //       padding: const EdgeInsets.only(top: 22, bottom: 23),
                              //       decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(30),
                              //         color: Theme.of(context).cardColor,
                              //         boxShadow: [
                              //           BoxShadow(
                              //             color: Theme.of(context).shadowColor.withOpacity(0.2), // Use shadowColor from the theme with opacity
                              //             spreadRadius: 2, // Spread radius of the shadow
                              //             blurRadius: 4, // Blur radius of the shadow
                              //             offset: const Offset(0, 2), // Offset of the shadow
                              //           ),
                              //         ],
                              //       ),
                              //       child: Row(
                              //         mainAxisSize: MainAxisSize.min,
                              //         mainAxisAlignment: MainAxisAlignment.center,
                              //         crossAxisAlignment: CrossAxisAlignment.center,
                              //         children: [
                              //           Row(
                              //             mainAxisSize: MainAxisSize.min,
                              //             mainAxisAlignment: MainAxisAlignment.start,
                              //             crossAxisAlignment: CrossAxisAlignment.center,
                              //             children: [
                              //               SizedBox(
                              //                   width: 25,
                              //                   height: 25,
                              //                   child:
                              //                   SvgPicture.asset(
                              //                     Images.facebookIcon,
                              //                     height: 25,
                              //                     width: 25,
                              //                   )
                              //               ),
                              //             ],
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // )
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
