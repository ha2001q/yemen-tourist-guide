


import 'dart:io';
import 'dart:convert';  // Importing to decode the JSON response
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:http/http.dart'as http;
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';


class ProfileController extends GetxController {
  // A variable to store the user data.
  var userData = <String, dynamic>{}.obs;
  var isUploading = false.obs; // ✅ Track loading state
  // UserController userController=Get.put(UserController());

  // Firestore instance.
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // StreamSubscription to manage the listener.
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _userSubscription;

  // Method to listen to user data for a specific user_id.
  void listenToUser() {
    try {
      UserDataController.loadUser();
      var id = UserDataController.userId;
      // Listen to the collection snapshot for a specific user_id.
      if(id == '') {
        return;
      }
      _userSubscription = firestore
          .collection('Users')
          .where('user_id', isEqualTo: id)
          .snapshots()
          .listen((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Update the userData observable with the first matching document.
          userData.value = querySnapshot.docs.first.data();

          // Log success.
          print('User data updated for userId ${id}: ${userData.value}');
        } else {
          // Handle the case where no matching documents are found.
          userData.value = {};
          print('No user data found for userId ${id}.');
        }
      });
    } catch (e) {
      // Handle errors.
      print('Error listening to user data for userId ${UserDataController.userId}: $e');
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




  // Future pickFile() async {
  //   final result = await FilePicker.platform.pickFiles();
  //   if(result==null){
  //     return;
  //   }else{
  //     pickImage = result.files.first; // Display the selected file immediately
  //     uploadFile();
  //
  //
  //   }
  // }
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom, // Specify custom types
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'], // Allowed image formats
    );

    if (result == null) {
      return;
    }

    pickImage = result.files.first;
    uploadFile();
    // Validate MIME type (Optional but recommended)

  }
  /// Uploads the file to Firebase Storage
  // Future<String?> uploadFile() async {
  //   final path = 'Images/${pickImage!.name}';
  //   final file = File(pickImage!.path!);
  //   final ref = FirebaseStorage.instance.ref().child(path);
  //   ref.putFile(file);
  //   TaskSnapshot snapshot = await ref.putFile(file);
  //   final downloadUrl = await snapshot.ref.getDownloadURL();
  //   print(downloadUrl.toString());
  //   imageUrl.value=downloadUrl;
  //   await updateUserImagePath(imageUrl.value);
  //
  //   UserDataController.loadUser();
  //   var id = UserDataController.userId;
  //   var name = UserDataController.userName;
  //   UserDataController.setUser(id, name, downloadUrl);
  //   UserDataController.loadUser();
  //
  //   return downloadUrl;
  // }

  Future<String?> uploadFile() async {
    try {
      isUploading.value = true; // ✅ Start loading
      final path = 'Images/${pickImage!.name}';
      final file = File(pickImage!.path!);

      UserDataController.loadUser();
      var userid = UserDataController.userId;
      // First request to upload the file
      var request = http.MultipartRequest('POST', Uri.parse('http://192.168.0.110:8000/upload-image/'));
      request.fields.addAll({
        'user_id': userid, // Replace with your user ID
      });
      request.files.add(await http.MultipartFile.fromPath('image', file.path));

      http.StreamedResponse response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print(responseBody); // Prints the response body (for debugging)

        // Parse the JSON response
        var responseData = json.decode(responseBody);

        // Extract the file URL from the response
        final downloadUrl = responseData['file_url'];
        print(downloadUrl.toString());

        // Assuming you are updating the user image path and other logic here
        imageUrl.value = downloadUrl; // Update image URL in your state
        // await updateUserImagePath(imageUrl.value);

        UserDataController.loadUser();
        var id = UserDataController.userId;
        var name = UserDataController.userName;
        UserDataController.setUser(id, name, downloadUrl);
        UserDataController.loadUser();
        isUploading.value = false; // ✅ Stop loading
        return downloadUrl; // Return the download URL
      } else {
        isUploading.value = false; // ✅ Stop loading
        print('Upload failed: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      isUploading.value = false; // ✅ Stop loading
      print('Error occurred: $e');
      return null;
    }
  }

  /// Updates the user's image path in Firestore
  // Future<void> updateUserImagePath( String imageUrl) async {
  //   try {
  //     UserDataController.loadUser();
  //     var id = UserDataController.userId;
  //     print("====================================");
  //     // Query the Users collection for the document with matching user_id
  //     var querySnapshot = await FirebaseFirestore.instance
  //         .collection('Users')
  //         .where('user_id', isEqualTo: id)
  //         .get();
  //
  //     if (querySnapshot.docs.isNotEmpty) {
  //       // Update the first matching document
  //       var docId = querySnapshot.docs.first.id;
  //       await FirebaseFirestore.instance
  //           .collection('Users')
  //           .doc(docId)
  //           .update({'user_image': imageUrl});
  //
  //       Get.snackbar("Success", "Profile image updated successfully!");
  //     } else {
  //       Get.snackbar("Error", "No user found with the given user ID.");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to update user image. Error: $e");
  //   }
  // }

  @override
  void onInit() {
    super.onInit();
    UserDataController.loadUser();
  }

}
