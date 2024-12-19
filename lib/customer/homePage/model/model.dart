import 'package:cloud_firestore/cloud_firestore.dart';
class PlacesModel {
  String? name;
  String? description;
  String? rate;
  int? id;


  PlacesModel(
      {this.name,
        this.description,
        this.rate,
        this.id,});

  PlacesModel.fromMap(DocumentSnapshot data) {
    name = data["name"];
    description = data["description"];
    rate = data["rate"];
    id = data["id"];
  }
}