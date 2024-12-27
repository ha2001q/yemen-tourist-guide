import 'package:get_storage/get_storage.dart';

class UserDataController {
  static final GetStorage _storage = GetStorage();
  static String userName = '';
  static String userId = '';
  static String userImage = '';

  // Load user from GetStorage
  static void loadUser() {
    userId = _storage.read('userId') ?? '';
    userName = _storage.read('userName') ?? '';
    userImage = _storage.read('userImage') ?? '';
  }

  // Add or Update user
  static void setUser(String id, String name, String image) {
    _storage.write('userId', id);
    _storage.write('userName', name);
    _storage.write('userImage', image);
    loadUser();
  }

  // Delete user
  static void deleteUser() {
    _storage.remove('userId');
    _storage.remove('userImage');
    _storage.remove('userName');
    loadUser();
  }
}
