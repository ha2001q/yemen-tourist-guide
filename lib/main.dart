import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yemen_tourist_guide/core/common_controller/user_data.dart';
import 'package:yemen_tourist_guide/core/locale/my_locale.dart';
import 'package:yemen_tourist_guide/customer/add_review/controller/review_controller.dart';
import 'package:yemen_tourist_guide/customer/add_review/view/review_screen.dart';
import 'package:yemen_tourist_guide/customer/add_review/view/test.dart';
import 'package:yemen_tourist_guide/customer/comment_screen/controller/comment_controller.dart';
import 'package:yemen_tourist_guide/customer/comment_screen/view/comment_screen.dart';
import 'package:yemen_tourist_guide/customer/favorite_screen/controller/favorite_controller.dart';
import 'package:yemen_tourist_guide/customer/favorite_screen/view/pages/favorite_screen.dart';
import 'package:yemen_tourist_guide/customer/homePage/controller/home_controller.dart';
import 'package:yemen_tourist_guide/customer/homePage/home_view/pages/all_places.dart';
import 'package:yemen_tourist_guide/customer/login_screen/controller/login_controller.dart';
import 'package:yemen_tourist_guide/customer/login_screen/view/login_screen.dart';
import 'package:yemen_tourist_guide/customer/map/view/pages/map_page.dart';
import 'package:yemen_tourist_guide/customer/place_details/view/place_details.dart';
import 'package:yemen_tourist_guide/customer/profile_screen/controller/profile_controller.dart';
import 'package:yemen_tourist_guide/customer/profile_screen/view/pages/profile_screen.dart';
import 'package:yemen_tourist_guide/customer/root_screen/root_screen.dart';
import 'package:yemen_tourist_guide/customer/search/view/search_screen.dart';
import 'package:yemen_tourist_guide/customer/setting_screen/view/setting_screen.dart';
import 'package:yemen_tourist_guide/customer/signup_screen/controller/signup_controller.dart';
import 'package:yemen_tourist_guide/customer/signup_screen/view/signup_screen.dart';
import 'package:yemen_tourist_guide/customer/splash_screen/controller/Splash_controller.dart';
import 'package:yemen_tourist_guide/customer/splash_screen/view/splash_screen.dart';

import 'customer/homePage/home_view/pages/home_screen.dart';
import 'notification.dart';

SharedPreferences? sharedPref;

class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize the notifications
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/logo'); // Replace with your app icon

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await _localNotificationsPlugin.initialize(initSettings);
  }

  // Show a notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      '1', // Unique channel ID
      'channel_name', // Channel name
      channelDescription: 'channel_description', // Channel description
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      id,       // Notification ID
      title,    // Notification title
      body,     // Notification body
      notificationDetails,
    );
  }
}
// Background message handler
Future<void> _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    // Ensure notifications are initialized
    await NotificationInitialize.initializeNotifications(flutterLocalNotificationsPlugin);

    var notificationService = NotificationService();
    await notificationService.initializeNotifications();
    notificationService = NotificationService();
    notificationService.showNotification(
      id: 1,
      title: message.notification!.title ?? "No Title",
      body: message.notification!.body ?? "No Body",
    );
    // Display the notification
    await NotificationInitialize.showNotification(
      title: message.notification!.title ?? "No Title",
      body: message.notification!.body ?? "No Body",
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    );
  }
}

//Foreground message handler
Future<void> _firebaseForegroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    // Ensure notifications are initialized
    await NotificationInitialize.initializeNotifications(flutterLocalNotificationsPlugin);

    var notificationService = NotificationService();
    await notificationService.initializeNotifications();
    notificationService = NotificationService();
    notificationService.showNotification(
      id: 1,
      title: message.notification!.title ?? "No Title",
      body: message.notification!.body ?? "No Body",
    );
    // Display the notification
    await NotificationInitialize.showNotification(
      title: message.notification!.title ?? "No Title",
      body: message.notification!.body ?? "No Body",
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  sharedPref = await SharedPreferences.getInstance();
  await Firebase.initializeApp();


  FirebaseMessaging.onMessage.listen(_firebaseForegroundMessage);
  // Set the background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  FirebaseMessaging.onBackgroundMessage(_firebaseForegroundMessage);


  /// this to make battery, notification icons fixable changes colors above the appbar.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),);

  // UserController userController = Get.put(UserController(), permanent: true);
  //
  // // userController.setUser('1', 'dheya', 'https://s.france24.com/media/display/cc2f52c0-b4eb-11ea-a534-005056a964fe/w:1280/p:16x9/yemen%20houthi%20sanaa%20reuters.jpg');
  // // userController.deleteUser();
  // userController.loadUser();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp(){
     _initializeFCM();
   }
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;





  void _initializeFCM() async {
    // Request notification permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User declined or has not accepted permission");
    }

    // Print the FCM token
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received in foreground: ${message.notification?.title}");
      print("Message body: ${message.notification?.body}");
    });

    // Handle messages when the app is opened from a background notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message opened: ${message.data}");
    });
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      locale: Get.deviceLocale,
      translations: MyLocal(),
      initialRoute: "/first",

      getPages: [
        GetPage(
            name: "/first",
            page: ()=>SplashScreen(),
            binding: BindingsBuilder(()=>Get.put(SplashController()))
        ),
        GetPage(
            name: "/home-page",
            page: ()=>HomePageScreen(),
            binding: BindingsBuilder(()=>Get.put(HomeController()))
        ),
        GetPage(
            name: "/profile",
            page: ()=>ProfileScreen(),
            binding: BindingsBuilder(()=>Get.put(ProfileController()))
        ),
        GetPage(
            name: "/root",
            page: ()=>RootScreen(),
            // binding: BindingsBuilder(()=>Get.put(ProfileController()))
        ),
        GetPage(
          name: "/placeDetailes",
          page: ()=>PlaceDetails(),
          // binding: BindingsBuilder(()=>Get.put(ProfileController()))
        ),
        GetPage(
            name: "/favorite",
            page: ()=>FavoriteScreen(),
            binding: BindingsBuilder(()=>Get.put(FavoriteController()))
        ),
        GetPage(
            name: "/login",
            page: ()=>LoginScreen(),
            binding: BindingsBuilder(()=>Get.put(LoginController()))
        ),
        GetPage(
            name: "/sign",
            page: ()=>SignupScreen(),
            binding: BindingsBuilder(()=>Get.put(SignupController()))
        ),
        GetPage(
            name: "/all_places",
            page: ()=>AllPlacesScreen(),
            // binding: BindingsBuilder(()=>Get.put(SignupController()))
        ),
        GetPage(
          name: "/map_page",
          page: ()=>MapWithLineScreen(),
          // binding: BindingsBuilder(()=>Get.put(SignupController()))
        ),
        GetPage(
          name: "/add_review",
          page: ()=>ReviewScreen(),
          binding: BindingsBuilder(()=>Get.put(ReviewController()))
        ),
        GetPage(
            name: "/comments",
            page: ()=>CommentScreen(),
            binding: BindingsBuilder(()=>Get.put(CommentController()))
        ),
        GetPage(
            name: "/Setting",
            page: ()=>SettingScreen(),
            // binding: BindingsBuilder(()=>Get.put(CommentController()))
        ),
        GetPage(
          name: "/search",
          page: ()=>SearchScreen(),
          // binding: BindingsBuilder(()=>Get.put(CommentController()))
        ),
      ],


      ///////////////////////////////////////////////////////////////////////


    );
  }
}




