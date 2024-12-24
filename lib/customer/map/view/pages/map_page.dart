import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapWithLineScreen extends StatefulWidget {
  @override
  _MapWithLineScreenState createState() => _MapWithLineScreenState();
}

class _MapWithLineScreenState extends State<MapWithLineScreen> {
  late GoogleMapController _mapController;
  LatLng _initialPosition = const LatLng(0.0, 0.0);
  LatLng _destinationPosition = const LatLng(24.7136, 46.6753); // Example: Riyadh, KSA
  Marker? _startMarker;
  Marker? _endMarker;
  Set<Polyline> _polylines = {};
  var arguments = Get.arguments;

  @override
  void initState() {
    super.initState();
    _destinationPosition = LatLng(double.parse(arguments['lat']), double.parse(arguments['lon']));
    _setMarkersAndLine();
  }

  Future<void> _setMarkersAndLine() async {
    try {
      // Get the current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng currentLocation = LatLng(position.latitude, position.longitude);

      // Set markers for start and destination
      setState(() {
        _initialPosition = currentLocation;
        _startMarker = Marker(
          markerId: const MarkerId("startMarker"),
          position: currentLocation,
          infoWindow: const InfoWindow(title: "Start Location"),
        );
        _endMarker = Marker(
          markerId: const MarkerId("endMarker"),
          position: _destinationPosition,
          infoWindow: const InfoWindow(title: "Destination"),
        );
      });

      // Fetch the directions from the API
      await _getRouteFromAPI(currentLocation, _destinationPosition);

      // Move the camera to show the route
      _mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
              currentLocation.latitude < _destinationPosition.latitude
                  ? currentLocation.latitude
                  : _destinationPosition.latitude,
              currentLocation.longitude < _destinationPosition.longitude
                  ? currentLocation.longitude
                  : _destinationPosition.longitude,
            ),
            northeast: LatLng(
              currentLocation.latitude > _destinationPosition.latitude
                  ? currentLocation.latitude
                  : _destinationPosition.latitude,
              currentLocation.longitude > _destinationPosition.longitude
                  ? currentLocation.longitude
                  : _destinationPosition.longitude,
            ),
          ),
          100, // Padding
        ),
      );
    } catch (e) {
      print("Error: $e");
    }
  }
// Function to fetch the route from Google Maps Directions API
  Future<void> _getRouteFromAPI(LatLng origin, LatLng destination) async {
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=AIzaSyBadvdbDUOBWaod8XbuA2AB5Ot4cdoiKfY";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Check if the response contains routes and legs
        if (data['routes'].isNotEmpty) {
          var route = data['routes'][0]['legs'][0]['steps'];
          List<LatLng> polylinePoints = [];

          for (var step in route) {
            var lat = step['end_location']['lat'];
            var lng = step['end_location']['lng'];
            polylinePoints.add(LatLng(lat, lng));
          }

          setState(() {
            _polylines.add(Polyline(
              polylineId: const PolylineId("route"),
              points: polylinePoints,
              color: Colors.blue,
              width: 5,
              geodesic: true,  // Ensures that the polyline follows the curvature of the Earth.
            ));
          });
        } else {
          throw Exception('No routes found in the response');
        }
      } else {
        throw Exception('Failed to load directions');
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
  }

  // Function to fetch the route from Google Maps Directions API
  // Future<void> _getRouteFromAP1I(LatLng origin, LatLng destination) async {
  //   final String url =
  //       "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=AIzaSyBadvdbDUOBWaod8XbuA2AB5Ot4cdoiKfY";
  //
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //
  //     if (response.statusCode == 200) {
  //       var data = json.decode(response.body);
  //       var route = data['routes'][0]['legs'][0]['steps'];
  //       List<LatLng> polylinePoints = [];
  //
  //       for (var step in route) {
  //         var lat = step['end_location']['lat'];
  //         var lng = step['end_location']['lng'];
  //         polylinePoints.add(LatLng(lat, lng));
  //       }
  //
  //       setState(() {
  //         _polylines.add(Polyline(
  //           polylineId: const PolylineId("route"),
  //           points: polylinePoints,
  //           color: Colors.blue,
  //           width: 5,
  //         ));
  //       });
  //     } else {
  //       throw Exception('Failed to load directions');
  //     }
  //   } catch (e) {
  //     print("Error fetching route: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map with Line"),
      ),
      body: _initialPosition.latitude != 0.0
          ? GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 12.0,
        ),
        onMapCreated: (controller) => _mapController = controller,
        markers: {
          if (_startMarker != null) _startMarker!,
          if (_endMarker != null) _endMarker!,
        },
        polylines: _polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
