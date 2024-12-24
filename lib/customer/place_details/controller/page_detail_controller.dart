
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';
import 'package:yemen_tourist_guide/customer/place_details/data/page_detial_repo.dart';

class PageDetailController extends GetxController{

  final PageDetailRepo _pageDetailRepo = PageDetailRepo();
  final UserController _userController = UserController();

  RxBool isRed = false.obs;

  RxInt placeIdd = 0.obs;




  @override
  void onInit() {
    super.onInit();

    _userController.loadUser();


    // checkIf(int.parse(_userController.userId.value), placeIdd.value);

  }


  void addFavorite(int placeId, String userId) async{
    var add = await _pageDetailRepo.createFavorite(userId, placeId);

    if(add == 'done'){

      isRed.value = true;

    } else if(add == 'delete'){
      isRed.value = false;
    } else if(add == 'login'){
      Get.toNamed('login');
    }
  }

  void checkIf(int userId,int placeId)async{
    placeIdd.value = placeId;
    // Perform necessary logic, e.g., API call
    Future.delayed(Duration.zero, () async {
      isRed.value = await _pageDetailRepo.checkFavorite(userId, placeId); // Safe update outside the build phase
    });
  }
}