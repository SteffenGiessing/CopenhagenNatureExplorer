import 'dart:collection';
import 'dart:async';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class DirectionHelper {
  //Map from Meters from station.
  HashMap<String, int> metersFromStation = new HashMap();

  //Used to find nearest Station.
  HashMap<String, LatLng> stations = new HashMap();
  HashMap<String, LatLng> nearestFinalStation = new HashMap();

  //User Location.
  Location location = new Location();
  LocationData _locationData;

  //Getting collection reference trainStations to fetch all stations
  CollectionReference firestoreStations =
      FirebaseFirestore.instance.collection("trainStations");

  //Polyline Coordinates List.
  List<LatLng> polyLinesCoordinates1 = [];
  List<LatLng> polyLinesCoordinates2 = [];

  //Responsible for finding the closest station to the current slected marker.
  Future<HashMap<String, LatLng>> getTrainStations(
      double currentMarkerLat, double currentMarkerLot) async {
    if (nearestFinalStation.isNotEmpty) {
      nearestFinalStation.clear();
    }
    if (stations.isEmpty) {
      //Database Call to get all stations
      var snapshot = await firestoreStations.get().then((querySnapshot) async {
        querySnapshot.docs.forEach((element) async {
          stations[element["key"]] =
              LatLng(element["latitude"], element["longitude"]);

          //Iterates through each station in the list and convert the distance to meters.
          double distance = Geolocator.distanceBetween(currentMarkerLat,
              currentMarkerLot, element["latitude"], element["longitude"]);

          int distanceInMeter = distance.toInt();

          metersFromStation[element["key"]] = distanceInMeter;
        });

        //creating a list and sorting with the lowest value first to find closest station.
        var sort = Map.fromEntries(metersFromStation.entries.toList()
          ..sort((e1, e2) => e1.value.compareTo(e2.value)));

        String closestStation = sort.entries.first.key.toString();

        //Using the key from previous list to determine which station is the closest.
        //Return a new Map with only the closest station.
        stations.forEach((key, value) {
          if (key == closestStation) {
            nearestFinalStation[key] = value;
            return nearestFinalStation;
          }
        });
        return nearestFinalStation;
      });
    } else {
      stations.forEach((key, value) {
        //Iterates through each station in the list and convert the distance to meters.
        double distance = Geolocator.distanceBetween(currentMarkerLat,
            currentMarkerLot, value.latitude, value.longitude);
        int distanceInMeter = distance.toInt();
        metersFromStation[key] = distanceInMeter;
      });

      //creating a list and sorting with the lowest value first to find closest station.
      var sort = Map.fromEntries(metersFromStation.entries.toList()
        ..sort((e1, e2) => e1.value.compareTo(e2.value)));
      String closestStation = sort.entries.first.key.toString();

      //Using the key from previous list to determine which station is the closest.
      //Return a new Map with only the closest station.
      stations.forEach((key, value) {
        if (key == closestStation) {
          nearestFinalStation[key] = value;
          return nearestFinalStation;
        }
      });
      return nearestFinalStation;
    }
    return nearestFinalStation;
  }

  //Assamble markers for the map.
  Future<Set<Marker>> assambleMarkers(HashMap<String, LatLng> getNearestStation,
      double _currentMarkerLat, double _currentMarkerLot) async {
    Set<Marker> markers = new Set();

    HashMap<String, LatLng> combineMarkers = new HashMap();
    _locationData = await location.getLocation();

    combineMarkers["Your Location"] =
        LatLng(_locationData.latitude, _locationData.longitude);
    combineMarkers["Destination"] =
        LatLng(_currentMarkerLat, _currentMarkerLot);
    combineMarkers.addAll(getNearestStation);

    combineMarkers.forEach((key, value) async {
      Marker marker = Marker(
        markerId: MarkerId(key),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: InfoWindow(
          title: key,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );
      markers.add(marker);
    });
    return markers;
  }

  // Builds the parameters for polyline Coordinates for User location to Station
  Future<List<LatLng>> userLocationToStation(
      Map<String, LatLng> station) async {
    _locationData = await location.getLocation();
    station.forEach((key, value) async {
      polyLinesCoordinates1
          .add(LatLng(_locationData.latitude, _locationData.longitude));
      polyLinesCoordinates1.add(LatLng(value.latitude, value.longitude));
    });
    return polyLinesCoordinates1;
  }

  // Builds the parameters for polyline Coordinates for Station to destination
  Future<List<LatLng>> stationToDestination(Map<String, LatLng> station,
      double _currentMarkerlat, double _currentMarkerLot) async {
    station.forEach((key, value) async {
      polyLinesCoordinates2.add(LatLng(value.latitude, value.longitude));
      polyLinesCoordinates2.add(LatLng(_currentMarkerlat, _currentMarkerLot));
    });
    return polyLinesCoordinates2;
  }
}
