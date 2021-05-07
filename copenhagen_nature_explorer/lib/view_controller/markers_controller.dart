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

  MarkersController() {
    init = initMarker();
    init = initRouteMarkers();
    init = initNearestStation();
    init = initMetersToMarkers();
  }

  Future<MarkerCreator> initMarker() async {
    _markerCreator = MarkerCreator();
    return _markerCreator;
  }

  Future<RouteMarkers> initRouteMarkers() async {
    _routeMarkers = RouteMarkers();
    return _routeMarkers;
  }

  Future<NearestStation> initNearestStation() async {
    _nearestStation = NearestStation();
    return _nearestStation;
  }

  Future<MetersToMarkers> initMetersToMarkers() async {
    _metersToMarkers = MetersToMarkers();
    return _metersToMarkers;
  }

  MarkerCreator get marker => _markerCreator;
  RouteMarkers get markersList => _routeMarkers;
  NearestStation get nearestStation => _nearestStation;
  MetersToMarkers get metersToMarkers => _metersToMarkers;

  Future<HashMap<String, LatLng>> createMarkers() async {
    return await _firebaseRepo.getUserPost();
  }

  Future<MarkerCreator> getMarkerInfo({String key}) async {
    _markerCreator = await _firebaseRepo.getMarkerInfo(key);
    return MarkerCreator(
        pictureUrl: _markerCreator.pictureUrl,
        displayName: _markerCreator.displayName,
        infoText: _markerCreator.infoText);
  }

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

  Future<List<LatLng>> createPolyLines() async {
    MarkerCreator _currentMarker = MarkerCreator();
    NearestStation _nearestStation =
        locator.get<MarkersController>().nearestStation;
    return await _directionHelper.createPolylines(
        _nearestStation.nearestStation,
        _currentMarker.latitude,
        _currentMarker.longitude);
  }

  Future<List<LatLng>> userLocationToStation(
      Map<String, LatLng> station) async {
    return await _directionHelper.userLocationToStation(station);
  }

  Future<List<LatLng>> stationToDestination(Map<String, LatLng> station) async {
    MarkerCreator _currentMarker = locator.get<MarkersController>().marker;
    return await _directionHelper.stationToDestination(
        station, _currentMarker.latitude, _currentMarker.longitude);
  }

  Future<MetersToMarkers> setupMetersToMarkers() async {
    MarkerCreator _currentMarker = locator.get<MarkersController>().marker;
    NearestStation _nearestStation =
        locator.get<MarkersController>().nearestStation;
    _metersToMarkers = await _directionHelper.metersToMarkers(
        _currentMarker.latitude,
        _currentMarker.longitude,
        _nearestStation.nearestStation);
    print("These ${_metersToMarkers.metersFromLocationToStation}");
    print(_metersToMarkers.metersFromStationToDestination);
    return MetersToMarkers(
        metersFromLocationToStation:
            _metersToMarkers.metersFromLocationToStation,
        metersFromStationToDestination:
            _metersToMarkers.metersFromStationToDestination);
  }
}
