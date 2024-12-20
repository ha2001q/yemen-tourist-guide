import 'package:get/get.dart';

import 'arabic.dart';
import 'english.dart';

class MyLocal extends Translations{



  @override
  Map<String, Map<String, String>> get keys => {
    'ar': arabic,
    'en': english
  };

}