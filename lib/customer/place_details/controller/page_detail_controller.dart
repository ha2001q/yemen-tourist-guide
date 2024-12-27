
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';
import 'package:yemen_tourist_guide/customer/place_details/data/page_detial_repo.dart';
import '../../homePage/controller/home_controller.dart';

class PageDetailController extends GetxController {
  final PageDetailRepo _pageDetailRepo = PageDetailRepo();
  final HomeController homeController = Get.find();

  RxBool isRed = false.obs;
  RxString placeIdd = ''.obs;
  var arguments = Get.arguments;
  final Rx<Map<String, dynamic>?> placeData = Rx<Map<String, dynamic>?>(null);


  var userId;


  @override
  void onInit()  {
    super.onInit();

    // Extract placeId from arguments
    UserDataController.loadUser();
    var id = UserDataController.userId;
    placeIdd.value = arguments['place'];

    print("*******************************${placeIdd.value}");
    // Listen to services for the given placeId
    homeController.listenToServices(int.parse(placeIdd.value));

    // Load user data

    userId = id;

    // Fetch place details and check favorite status
    getPlace(placeIdd.value);
    print(placeData);
    if(userId==''){
      return;
    }
    checkIf(userId, placeIdd.value);
  }

  void addFavorite(String placeId, String userId) async {
    var result = await _pageDetailRepo.createFavorite(userId, placeId);

    if (result == 'done') {
      isRed.value = true;
    } else if (result == 'delete') {
      isRed.value = false;
    } else if (result == 'login') {
      Get.toNamed('login');
    }
  }

  void getPlace(String placeId) {
    try {
      // Subscribe to the stream from the repository method
      _pageDetailRepo.getPlaceByPlaceId(placeId).listen((data) {
        // Update the reactive variable with the new data
        placeData.value = data;
      }, onError: (e) {
        print("Error fetching place: $e");
      });
    } catch (e) {
      print("Error fetching place: $e");
    }
  }

  Future<void> checkIf(String userId, String placeId) async {
    try {
      isRed.value = await _pageDetailRepo.checkIfIsFavorite(userId, placeId);
    } catch (e) {
      print("Error checking favorite status: $e");
    }
  }
}