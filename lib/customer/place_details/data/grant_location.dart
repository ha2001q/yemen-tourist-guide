import 'package:permission_handler/permission_handler.dart';

Future<bool?> requestLocationPermission() async {
  // Check the current permission status
  var status = await Permission.location.request();

  // Handle the different statuses
  if (status.isGranted) {
    return true;
    print("Location permission granted.");
  } else if (status.isDenied) {
    return false;
    print("Location permission denied. Please grant it for the app to work properly.");
  } else if (status.isPermanentlyDenied) {
    print("Location permission is permanently denied. Redirecting to settings...");
    openAppSettings(); // Opens the app settings for the user to manually grant permissions
    return false;
  } else if (status.isRestricted) {
    print("Location permission is restricted (e.g., parental controls).");
    return false;
  }
}
