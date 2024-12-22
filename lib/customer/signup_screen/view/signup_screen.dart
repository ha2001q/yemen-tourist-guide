import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/utils/images.dart';
import '../../../core/utils/styles.dart';
import '../../login_screen/view/login_screen.dart';
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    final _SignUpForm = GlobalKey<FormState>();

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
                        Text("Sign Up",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                        SizedBox(height: 54,),
                        Text("Happy to see you again! Please enter your email and",style: TextStyle(color: Colors.grey),),
                        Text("password to login to your account.",style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 110,),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xffDBC9BD),
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
                                      hintText:"Full Name",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "enter Full name";
                                      }
                                      if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value!)) {
                                        return "just_letter";
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
                                      hintText:"Email",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "enter Email";
                                      }
                                      if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value!)) {
                                        return "just_letter";
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "enter password";
                                      }
                                      if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value!)) {
                                        return "just_letter";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      password = password;
                                      // = value!;
                                    },
                                    controller:password,
                                    keyboardType: TextInputType.visiblePassword,
                                  ),
                                  SizedBox(height: 50,),
                                  InkWell(
                                      onTap:(){
                                        if (_SignUpForm.currentState!.validate()) {
                                          try{
                                            name = name.text as TextEditingController;
                                            email = email.text as TextEditingController;
                                            password = password.text as TextEditingController;

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
                            Text("Already have an account? ",style: fontMedium,),
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                              },
                              child:Text("  Login",style: TextStyle(color: Color(0xffD87234)),),
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
