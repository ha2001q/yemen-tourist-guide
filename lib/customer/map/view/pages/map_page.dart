import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

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

  String _duration = '';
  String _distance = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _destinationPosition = LatLng(double.parse(arguments['lat']), double.parse(arguments['lon']));
    _setMarkersAndLine();
  }

  Future<void> _setMarkersAndLine() async {
    setState(() {
      _isLoading = true;
    });

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
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), // Custom marker color
        );
        _endMarker = Marker(
          markerId: const MarkerId("endMarker"),
          position: _destinationPosition,
          infoWindow: const InfoWindow(title: "Destination"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), // Custom marker color
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
    } finally {
      setState(() {
        _isLoading = false;
      });
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
          var route = data['routes'][0]['legs'][0];

          // Extract duration and distance
          var duration = route['duration']['text'];
          var distance = route['distance']['text'];

          setState(() {
            _duration = duration;
            _distance = distance;

            var steps = route['steps'];
            List<LatLng> polylinePoints = [];

            for (var step in steps) {
              var lat = step['end_location']['lat'];
              var lng = step['end_location']['lng'];
              polylinePoints.add(LatLng(lat, lng));
            }

            // Add polyline with smooth line style
            _polylines.add(Polyline(
              polylineId: const PolylineId("route"),
              points: polylinePoints,
              color: Colors.deepOrange, // Deep orange color for the route
              width: 6,
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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Route Map"),
        backgroundColor: Colors.deepOrange,
        elevation: 5.0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          // Google Map as the background
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12.0,
              tilt: 45.0, // Tilt for 3D view
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: {
              if (_startMarker != null) _startMarker!,
              if (_endMarker != null) _endMarker!,
            },
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true, // Enable compass to rotate the map
            rotateGesturesEnabled: true, // Allow rotation gesture
            tiltGesturesEnabled: true, // Allow tilt gestures
            mapType: MapType.hybrid, // Hybrid mode for satellite + terrain view
            onCameraMove: (position) {
              // This can be used for any additional logic on camera movement
            },
          ),


          // Overlay: Information Section
          Positioned(
            bottom: 100.0,
            left: 16.0,
            right: 16.0,
            child: Card(
              elevation: 8.0,
              color: Colors.white.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Duration: $_duration',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Distance: $_distance',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Floating Action Button to Refresh Route
          Positioned(
            top: 10.0,
            left: 20.0,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _setMarkersAndLine();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Route has been refreshed')),
                );
              },
              backgroundColor: Colors.deepOrange,
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}
