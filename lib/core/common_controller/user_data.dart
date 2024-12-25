import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';


class UserController extends GetxController {
  final storage = GetStorage();
  var userName = ''.obs;
  var userId = ''.obs;
  var userImage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  // Load user from GetStorage
  void loadUser() {
    userId.value = storage.read('userId') ?? '';
    userName.value = storage.read('userName') ?? '';
    userImage.value = storage.read('userImage') ?? '';
  }


  // Add or Update user
  void setUser(String id, String name, String image) {
    storage.write('userId', id);
    storage.write('userName', name);
    storage.write('userImage', image);
    loadUser();
  }

  // Delete user
  void deleteUser() {
    storage.remove('userId');
    storage.remove('userImage');
    storage.remove('userName');
    loadUser();
  }

}