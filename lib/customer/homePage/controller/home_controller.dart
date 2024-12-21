
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';

import '../data/banner_model.dart';
import '../data/cities_service.dart';

class HomeController extends GetxController{

  RxBool isGuest = false.obs;
  var locationData = <String, String>{}.obs;
  UserController userController = Get.find();

  var cities = <Map<String, dynamic>>[].obs; // Observable list to store city data as maps
  var isLoading = true.obs; // Loading state
  var errorMessage = ''.obs; // Error message if any

  final FirebaseService firebaseService = FirebaseService();
  var cityId = 0.obs;



  // Variable to keep track of the selected option
  var selectedOption = 'All'.obs;



  // Observable for banners list, loading, and error message
  RxList<BannerModel> banners = <BannerModel>[].obs;
  RxBool isLoadingB = false.obs;
  RxString errorMessageB = ''.obs;

  // Firestore reference to 'banners' collection
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    var id = userController.userId.value;
    if(id == ''){
      isGuest.value = true;
      print('is guest ${id}');
    } else {
      isGuest.value = false;
      print('is not guest ${id}');
    }
    fetchAllCities(); // Fetch cities when the controller is initialized
    fetchBanners();
  }


  // Function to fetch location data and update the reactive variable
  Future<void> fetchLocationData() async {
    final url = Uri.parse('http://ip-api.com/json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      locationData.value = {
        'country': data['country'] ?? 'N/A',
        'ip': data['query'] ?? 'N/A',
        'city': data['city'] ?? 'N/A',
        'isp': data['isp'] ?? 'N/A',
      };
    } else {
      locationData.value = {
        'country': 'N/A',
        'ip': 'N/A',
        'city': 'N/A',
        'isp': 'N/A',
      };
    }
  }


  // Method to fetch cities from Firebase
  void fetchAllCities() {
    try {
      isLoading(true); // Set loading state to true
      firebaseService.getAllCities().listen((fetchedCities) {
        cities.assignAll(fetchedCities); // Update the cities list
      }, onError: (error) {
        errorMessage.value = error.toString(); // Store error message if there's an error
      });
    } catch (e) {
      errorMessage.value = e.toString(); // Handle unexpected errors
    } finally {
      isLoading(false); // Set loading state to false after stream setup
    }
  }


  // Stream to listen for banner updates from Firebase Firestore
  Stream<List<BannerModel>> get bannersStream {
    return _firestore.collection('Banners').snapshots().map(
          (QuerySnapshot snapshot) {
        return snapshot.docs.map((doc) {
          // Mapping Firestore document to BannerModel
          return BannerModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      },
    );
  }

  // Fetch banners and update observable list
  void fetchBanners() async {
    try {
      isLoadingB(true);
      banners.bindStream(bannersStream); // Bind the Firestore stream to banners
    } catch (e) {
      errorMessageB.value = e.toString();
    } finally {
      isLoadingB(false);
    }
  }

}