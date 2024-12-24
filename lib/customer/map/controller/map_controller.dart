
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/customer/map/data/get_current_location.dart';

class MapController extends GetxController{

  RxMap<dynamic, dynamic> currentLocation = {}.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    currentLocation.value = await getCurrentLocation();
    print(currentLocation.value);

  }
}