


import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';


class ProfileController extends GetxController {
  // A variable to store the user data.
  var userData = <String, dynamic>{}.obs;

  UserController userController=Get.put(UserController());

  // Firestore instance.
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // StreamSubscription to manage the listener.
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _userSubscription;

  // Method to listen to user data for a specific user_id.
  void listenToUser() {
    try {
      // Listen to the collection snapshot for a specific user_id.
      if(userController.userId.value == '') {
        return;
      }
      _userSubscription = firestore
          .collection('Users')
          .where('user_id', isEqualTo: userController.userId.value)
          .snapshots()
          .listen((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Update the userData observable with the first matching document.
          userData.value = querySnapshot.docs.first.data();

          // Log success.
          print('User data updated for userId ${userController.userId.value}: ${userData.value}');
        } else {
          // Handle the case where no matching documents are found.
          userData.value = {};
          print('No user data found for userId ${userController.userId.value}.');
        }
      });
    } catch (e) {
      // Handle errors.
      print('Error listening to user data for userId ${userController.userId.value}: $e');
    }
  }

  @override
  void onClose() {
    super.onClose();
    // Cancel the subscription when the controller is disposed.
    _userSubscription?.cancel();
  }



  PlatformFile? pickImage;
  var imageUrl = "".obs;




  Future pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if(result==null){
      return;
    }else{
      pickImage = result?.files.first; // Display the selected file immediately
      uploadFile();


    }
  }

  /// Uploads the file to Firebase Storage
  Future<String?> uploadFile() async {
    final path = 'Images/${pickImage!.name}';
    final file = File(pickImage!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
    TaskSnapshot snapshot = await ref.putFile(file);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print(downloadUrl.toString());
    imageUrl.value=downloadUrl;
    await updateUserImagePath(imageUrl.value);
    userController.userImage.value = imageUrl.value;
    return downloadUrl;
  }


  /// Updates the user's image path in Firestore
  Future<void> updateUserImagePath( String imageUrl) async {
    try {
      print("====================================");
      // Query the Users collection for the document with matching user_id
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('user_id', isEqualTo: userController.userId.value)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the first matching document
        var docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(docId)
            .update({'user_image': imageUrl});

        Get.snackbar("Success", "Profile image updated successfully!");
      } else {
        Get.snackbar("Error", "No user found with the given user ID.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update user image. Error: $e");
    }
  }


}
