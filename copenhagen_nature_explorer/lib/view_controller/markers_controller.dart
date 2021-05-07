import 'dart:collection';
import 'package:copenhagen_nature_explorer/models/directionHelper.dart';
import 'package:copenhagen_nature_explorer/models/metersToMarkers.dart';
import 'package:copenhagen_nature_explorer/repository/database_repo.dart';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/models/markersModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkersController {

  MarkerCreator _markerCreator;
  RouteMarkers _routeMarkers;
  NearestStation _nearestStation;
  MetersToMarkers _metersToMarkers;
  DirectionHelper _directionHelper = new DirectionHelper();
  FirebaseRepo _firebaseRepo = locator.get<FirebaseRepo>();
  Set<Marker> markers = new Set();
  Future init;

  //Init
  MarkersController() {
    init = initMarker();
    init = initRouteMarkers();
    init = initNearestStation();
    init = initMetersToMarkers();
  }
  //Init MarkerCreator model under class markersModel.dart.
  Future<MarkerCreator> initMarker() async {
    _markerCreator = MarkerCreator();
    return _markerCreator;
  }
  //Init RouteMarkers model under class markersModel.dart.
  Future<RouteMarkers> initRouteMarkers() async {
    _routeMarkers = RouteMarkers();
    return _routeMarkers;
  }
  //Init NearestStation model under class markersModel.dart.
  Future<NearestStation> initNearestStation() async {
    _nearestStation = NearestStation();
    return _nearestStation;
  }
  //Init MetersToMarkers model under metersToMarkers.dart.
  Future<MetersToMarkers> initMetersToMarkers() async {
    _metersToMarkers = MetersToMarkers();
    return _metersToMarkers;
  }
  //Callers.
  MarkerCreator get marker => _markerCreator;
  RouteMarkers get markersList => _routeMarkers;
  NearestStation get nearestStation => _nearestStation;
  MetersToMarkers get metersToMarkers => _metersToMarkers;

  //Creating markers for the Map.
  Future<HashMap<String, LatLng>> createMarkers() async {
    return await _firebaseRepo.getUserPost();
  }

  //Getting Specific marker infor from on click on marker.
  Future<MarkerCreator> getMarkerInfo({String key}) async {
    _markerCreator = await _firebaseRepo.getMarkerInfo(key);
    return MarkerCreator(
        pictureUrl: _markerCreator.pictureUrl,
        displayName: _markerCreator.displayName,
        infoText: _markerCreator.infoText);
  }

  //Calculates the closestStation to selected marker.
  Future<Set<Marker>> getClosestStation() async {
    MarkerCreator _currentMarker = locator.get<MarkersController>().marker;
    NearestStation _nearestStation =
        locator.get<MarkersController>().nearestStation;
    var getNearestStation = await _directionHelper.trainStations(
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
    return await _directionHelper.stationToDestination(
        station, _currentMarker.latitude, _currentMarker.longitude);
  }
  //Setup distance between markers
  Future<MetersToMarkers> setupMetersToMarkers() async {
    //Getting marker that user have picked.
    MarkerCreator _currentMarker = 
      locator.get<MarkersController>().marker;
    //Getting nearest Station to marker picked by user.
    NearestStation _nearestStation = 
      locator.get<MarkersController>().nearestStation;

    _metersToMarkers = await _directionHelper.metersToMarkers(
        _currentMarker.latitude,
        _currentMarker.longitude,
        _nearestStation.nearestStation);

    return MetersToMarkers(
        metersFromLocationToStation:
            _metersToMarkers.metersFromLocationToStation,
        metersFromStationToDestination:
            _metersToMarkers.metersFromStationToDestination);
  }
}
