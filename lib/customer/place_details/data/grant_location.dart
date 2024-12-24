import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermission() async {
  // Check the current permission status
  var status = await Permission.location.request();

  // Handle the different statuses
  if (status.isGranted) {
    print("Location permission granted.");
  } else if (status.isDenied) {
    print("Location permission denied. Please grant it for the app to work properly.");
  } else if (status.isPermanentlyDenied) {
    print("Location permission is permanently denied. Redirecting to settings...");
    openAppSettings(); // Opens the app settings for the user to manually grant permissions
  } else if (status.isRestricted) {
    print("Location permission is restricted (e.g., parental controls).");
  }
}
