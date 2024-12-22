
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageRepo{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// get the banners by city id
  Stream<List<Map<String, dynamic>>> streamBannersByCityId(int cityId) {
    if(cityId == null || cityId == 0){
      return _firestore
          .collection('Banners')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            "title": data['title'],
            "description": data['description'],
            "image": data['image'],
            "start_time": data['start_time'],
            "end_time": data['end_time'],
            "is_active": data['is_active'],
          };
        }).toList();
      });
    } else {
      return _firestore
          .collection('Banners')
          .where('city_id', isEqualTo: cityId)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            "title": data['title'],
            "description": data['description'],
            "image": data['image'],
            "start_time": data['start_time'],
            "end_time": data['end_time'],
            "is_active": data['is_active'],
          };
        }).toList();
      });
    }

  }


  /// get the types
  Stream<List<Map<String, dynamic>>> streamTypes() {
      return _firestore
          .collection('Places_type')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            "type_icon": data['type_icon'],
            "type_id": data['type_id'],
            "type_name": data['type_name']
          };
        }).toList();
      });

  }

  /// get the places by place type and city id
  Stream<List<Map<String, dynamic>>> streamPlacesByCityIdAndType(int cityId, int typeId) {
    if(cityId == 0){
      return _firestore
          .collection('Places')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          return data;
        }).toList();
      });
    } else {

      return _firestore
          .collection('Places')
          .where('city_id', isEqualTo: cityId).where('type_id', isEqualTo: typeId)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          return data;
        }).toList();
      });
    }

  }


  /// get the

}