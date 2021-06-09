import 'package:dio/dio.dart';
import 'package:copenhagen_nature_explorer/.env.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:copenhagen_nature_explorer/models/directionsModel.dart';

class DirectionsRepository {
  //Base Url for Directions API
  static const String _baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json?";

  final Dio _dio;
  DirectionsRepository({Dio dio}) : _dio = dio ?? Dio();

  PolylinePoints polylinePoints = PolylinePoints();

  List<LatLng> polylineCoordinates = [];
  

  //Building the Polyline Route in between User Location and Station marker
  Future<List<LatLng>> getLocationToStation(
      {@required LatLng location, @required LatLng station}) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(location.latitude, location.longitude),
      PointLatLng(station.latitude, station.longitude),
      travelMode: TravelMode.transit,
    );
    result.points.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });
    return polylineCoordinates;
  }

  //Building the Polyline Route in between Station and Destination marker
  Future<List<LatLng>> getStationToDestination(
      {@required LatLng station, @required LatLng destination}) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(station.latitude, station.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.walking,
    );
    result.points.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });
    return polylineCoordinates;
  }

  //Calling Directions API to get route details return a json format.
  Future<Directions> buildRoute(
      LatLng latlng1, LatLng latlng2, String mode) async {
    final response = await _dio.get(_baseUrl, queryParameters: {
      "origin": "${latlng1.latitude},${latlng1.longitude}",
      "destination": "${latlng2.latitude},${latlng2.longitude}",
      "mode": "$mode",
      "key": googleAPIKey,
    });
    if (response.statusCode == 200) {
      // Calling DirectionsModel to take the values out of json object.
      return Directions.fromMap(response.data, mode);
    }
    return null;
  }
}
