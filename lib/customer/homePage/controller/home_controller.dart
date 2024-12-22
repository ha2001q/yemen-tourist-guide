
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';
import 'package:yemen_tourist_guide/customer/homePage/data/home_page_repo.dart';

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

  // place types variables
  var selectedOptionTypes = 'All'.obs;
  var typeId = 0.obs;
  var types = <Map<String, dynamic>>[].obs;

  // places data variables
  var places = <Map<String, dynamic>>[].obs;




  // Observable for banners list, loading, and error message
  final HomePageRepo _repository = HomePageRepo();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var bannersd = <Map<String, dynamic>>[].obs;

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
    listenToBanners(0);
    listenToTypes();
    listenToPlaces(0, 0);
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


  void listenToBanners(int cityId) {
    _repository.streamBannersByCityId(cityId).listen((data) {
      bannersd.value = data;
    }, onError: (error) {
      Get.snackbar("Error", error.toString());
    });
  }


  void listenToTypes() {
    _repository.streamTypes().listen((data) {
      types.value = data;
    }, onError: (error) {
      Get.snackbar("Error", error.toString());
    });
  }


  void listenToPlaces(int cityId, int typeId) {
    _repository.streamPlacesByCityIdAndType(cityId, typeId).listen((data) {
      places.value = data;
    }, onError: (error) {
      Get.snackbar("Error", error.toString());
    });
  }
}