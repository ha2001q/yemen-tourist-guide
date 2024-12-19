import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:yemen_tourist_guide/main.dart';

class AuthMiddleWare extends GetMiddleware{

  @override
  RouteSettings? redirect(String? route){
    if(sharedPref?.getString("id") != null ) return RouteSettings(name: "/first");
  }
}