import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'get_route.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({required Dio dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': 'AIzaSyBt1m2KFCPjLY-BxanPE14HieKWTOucVAg',
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return throw Exception("No routes available in the response.");
  }
}


Future<List<LatLng>> getRouteCoordinates(
    LatLng start, LatLng end, String apiKey) async {
  final String url =
      'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey';

  try {
    // Send HTTP GET request
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the response body
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['routes'] != null && data['routes'].isNotEmpty) {
        // Extract encoded polyline
        final String encodedPolyline =
        data['routes'][0]['overview_polyline']['points'];

        // Decode the polyline to LatLng list
        return decodePolyline(encodedPolyline);
      } else {
        throw Exception('No routes found in the response.');
      }
    } else {
      throw Exception(
          'Failed to fetch directions. Status code: ${response.statusCode}');
    }
  } catch (error) {
    // Log the error
    print('Error fetching directions: $error');
    rethrow;
  }
}

List<LatLng> decodePolyline(String polyline) {
  List<LatLng> points = [];
  int index = 0;
  int length = polyline.length;
  int lat = 0;
  int lng = 0;

  while (index < length) {
    int shift = 0;
    int result = 0;
    int b;

    // Decode latitude
    do {
      b = polyline.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    int deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
    lat += deltaLat;

    shift = 0;
    result = 0;

    // Decode longitude
    do {
      b = polyline.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    int deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
    lng += deltaLng;

    // Add the decoded point to the list
    points.add(LatLng(lat / 1E5, lng / 1E5));
  }

  return points;
}
