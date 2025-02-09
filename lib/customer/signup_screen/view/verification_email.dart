import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/customer/root_screen/root_screen.dart';

import '../../../core/common_controller/user_data.dart';
import '../controller/email_verifcation.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, this.email, this.userName, this.image, this.password});

  final String? email;
  final String? userName;
  final String? image; // URL or placeholder for the image
  final String? password;

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final EmailVerificationStream _emailVerificationStream =
  EmailVerificationStream();

  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      // sendVerificationEmail();

      timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        checkEmailVerification();
      });
    }
  }

  Future<void> checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
      await createUserInFirestore();
      // Delay for 3 seconds before navigating to RootScreen
      Future.delayed(const Duration(seconds: 2), () {

        Get.offAllNamed('/root');
      });
    }
  }

  Future<void> createUserInFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final userId = user.uid; // Unique user ID from Firebase Authentication

      // Check if the user already exists in Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        String? token = await FirebaseMessaging.instance.getToken();
        await FirebaseFirestore.instance.collection('Users').doc(userId).set({
          'user_id': userId,
          'user_email': widget.email ?? user.email,
          'user_name': widget.userName ?? 'Anonymous',
          'user_image': widget.image ??
              'https://via.placeholder.com/150', // Default placeholder
          'user_created_at': FieldValue.serverTimestamp(),
          'user_token': token,
          'user_password': widget.password ?? 'noPassword'

        });
        UserDataController.setUser(user.uid, widget.userName.toString(), widget.email.toString());
        UserDataController.loadUser();
        Get.snackbar('Success', 'User created successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade800);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800);
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      Get.snackbar('Verification Email Sent',
          'Please check your inbox to verify your email.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800);
    } catch (e) {
      // Get.snackbar('Error', e.toString(),
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red.shade100,
      //     colorText: Colors.red.shade800);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 60.0,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Your email is verified!',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Redirecting to the home screen...',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    )
        : Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
        backgroundColor: Colors.orange.shade800,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.0,
                offset: const Offset(0, 5),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.mail_outline,
                color: Colors.orange,
                size: 80.0,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Email Verification Needed',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              const Text(
                'We’ve sent a verification link to your email. '
                    'Please check your inbox and verify your email address.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  sendVerificationEmail();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 12.0),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: const Text(
                  'Resend Verification Email',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue.shade50,
    );
  }
}
