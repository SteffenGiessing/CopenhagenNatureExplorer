import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/repository/firestore_repo.dart';
import 'package:copenhagen_nature_explorer/repository/direction_repo.dart';
import 'package:copenhagen_nature_explorer/repository/mapHelper_repo.dart';
import 'package:copenhagen_nature_explorer/models/markersModel.dart';
import 'package:copenhagen_nature_explorer/models/directionsModel.dart';

//Controls everything to do with markers.
class MarkersController {
  MarkerCreator _markerCreator;
  NearestStation _nearestStation;
  FirestoreRepo _firebaseRepo = locator.get<FirestoreRepo>();
  DirectionHelper _directionHelper = locator.get<DirectionHelper>();
  Set<Marker> markers = new Set();
  Future init;

  //Init
  MarkersController() {
    init = initMarker();
    init = initNearestStation();
  }
  //Init MarkerCreator model under class markersModel.dart.
  Future<MarkerCreator> initMarker() async {
    _markerCreator = MarkerCreator();
    return _markerCreator;
  }

  //Init NearestStation model under class markersModel.dart.
  Future<NearestStation> initNearestStation() async {
    _nearestStation = NearestStation();
    return _nearestStation;
  }

  //Callers.
  MarkerCreator get marker => _markerCreator;
  //RouteMarkers get markersList => _routeMarkers;
  NearestStation get nearestStation => _nearestStation;
  // MetersToMarkers get metersToMarkers => _metersToMarkers;

  //Creating markers for the Map.
  Future<HashMap<String, LatLng>> createMarkers() async {
    return await _firebaseRepo.getUserPost();
  }

  //Getting Specific marker info from on click on marker.
  //Storing the values in marker creator to enable them for later use if user decides to get directions.
  Future<MarkerCreator> getMarkerInfo({String key}) async {
    _markerCreator = await _firebaseRepo.getMarkerInfo(key);
    return MarkerCreator(
        pictureUrl: _markerCreator.pictureUrl,
        displayName: _markerCreator.displayName,
        infoText: _markerCreator.infoText);
  }

  //Getting closest station and returning it as a marker
  Future<Set<Marker>> getClosestStation() async {
    MarkerCreator _currentMarker = locator.get<MarkersController>().marker;
    NearestStation _nearestStation =
        locator.get<MarkersController>().nearestStation;
    var getNearestStation = await _directionHelper.getTrainStations(
        _currentMarker.latitude, _currentMarker.longitude);
    _nearestStation.nearestStation = getNearestStation;
    markers = await _directionHelper.assambleMarkers(
        _nearestStation.nearestStation,
        _currentMarker.latitude,
        _currentMarker.longitude);
    return markers;
  }

  //Creates Polyline from user Location to Station.
  Future<List<LatLng>> userLocationToStation(
      Map<String, LatLng> station) async {
    return await _directionHelper.userLocationToStation(station);
  }

  //Creates Polyline form station to destination.
  Future<List<LatLng>> stationToDestination(Map<String, LatLng> station) async {
    MarkerCreator _currentMarker = locator.get<MarkersController>().marker;
    var stationToDesti = _directionHelper.stationToDestination(
        station, _currentMarker.latitude, _currentMarker.longitude);
    return stationToDesti;
  }

  //Getting user location to station
  //Know issue calling directionRepo directly implemented for functionality know to be not correct
  Future<List<LatLng>> getLocationToStation(
      {@required LatLng location, @required LatLng station}) async {
    var locationToStation = await DirectionsRepository()
        .getLocationToStation(location: location, station: station);
    return locationToStation;
  }

  //Getting Station to Destination
  //Know issue calling directionRepo directly implemented for functionality know to be not correct
  Future<List<LatLng>> getStationToDestination(
      {@required LatLng station, @required LatLng destination}) async {
    var stationToDesti = await DirectionsRepository()
        .getStationToDestination(station: station, destination: destination);
    return stationToDesti;
  }

  //Calling BuildRoute - to create API request to recieve directions between two markers.
  //Know issue calling directionRepo directly implemented for functionality know to be not correct
  Future<Directions> builtRoute(
      LatLng latlng1, LatLng latlng2, String mode) async {
    var route = await DirectionsRepository().buildRoute(latlng1, latlng2, mode);
    return route;
  }
}
