import 'dart:collection';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:copenhagen_nature_explorer/models/metersToMarkers.dart';

class DirectionHelper {
  
  //Map from Meters from station.
  HashMap<String, int> metersFromStation = new HashMap();
  //Used to find nearest Station.
  HashMap<String, LatLng> stations = new HashMap();
  HashMap<String, LatLng> nearestFinalStation = new HashMap();

  //User Location.
  Location location = new Location();
  LocationData _locationData;

  //Polyline Coordinates List.
  List<LatLng> polyLinesCoordinates1 = [];
  List<LatLng> polyLinesCoordinates2 = [];

  //All the avaible station.
  Future<HashMap<String, LatLng>> trainStations(
      double currentMarkerLat, double currentMarkerLot) async {
    stations["Nørreport"] = LatLng(55.68372763388621, 12.57157366748944);
    stations["Sorgenfri St."] = LatLng(55.79587635096954, 12.484631615540279);
    stations["Gentofte"] = LatLng(55.77502715637621, 12.542309841188338);
    stations["Vangede St."] = LatLng(55.7503025494016, 12.521710474885458);
    stations["Bernstorffsvej Station"] =
        LatLng(55.7549396074304, 12.560162625317497);
    stations["Trianglen Station"] =
        LatLng(55.71241260531252, 12.572522245099224);
    stations["Nørrebroes Runddel St (Metro)"] =
        LatLng(55.699312291482485, 12.54933220394757);
    stations["Fuglebakken Station"] =
        LatLng(55.700622340614196, 12.529804438885444);
    stations["Grøndal"] = LatLng(55.695119839175014, 12.518180769205607);
    stations["Nuuks Plads St. (Metro)"] =
        LatLng(55.69407165583749, 12.543287895714053);
    stations["Frederiksberg"] = LatLng(55.686209384928965, 12.533059066395799);
    stations["Valby"] = LatLng(55.66943125578824, 12.512601407759284);
    stations["Forum"] = LatLng(55.68647148609793, 12.553516725032312);
    stations["Ny Ellebjerg"] = LatLng(55.65658063605955, 12.514926141695252);
    stations["Copenhagen Central Station"] =
        LatLng(55.674320218178984, 12.566418791696767);
    stations["Rådhuspladsen"] = LatLng(55.67858817600957, 12.568941827321202);

    //Iterates through each station in the list and convert the distance to meters. 
    
    stations.forEach((key, value) {
      double distance = Geolocator.distanceBetween(
          currentMarkerLat, currentMarkerLot, value.latitude, value.longitude);
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
  //Create the polyLines
  Future<List<LatLng>> createPolylines(HashMap<String, LatLng> nearestStation,
      double _currentMarkerLat, double _currentMarkerLot) async {
    List<LatLng> polyLinesCoordinates = [];
    PolylinePoints polylinePoints;
    _locationData = await location.getLocation();

    nearestStation.forEach((key, value) async {
      await polylinePoints
          .getRouteBetweenCoordinates(
        "AIzaSyBC-3s8CcMfSKWMoU96Bkb3c3gQ34QVdHM",
        PointLatLng(_locationData.latitude, _locationData.longitude),
        PointLatLng(value.latitude, value.longitude),
        travelMode: TravelMode.transit,
      )
          .then((value) {
        value.points.forEach((PointLatLng pointLatLng) {
          polyLinesCoordinates
              .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
        });
      });
    });
    return polyLinesCoordinates;
  }

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

  Future<List<LatLng>> stationToDestination(Map<String, LatLng> station,
      double _currentMarkerlat, double _currentMarkerLot) async {
    station.forEach((key, value) async {
      polyLinesCoordinates2.add(LatLng(value.latitude, value.longitude));
      polyLinesCoordinates2.add(LatLng(_currentMarkerlat, _currentMarkerLot));
    });
    return polyLinesCoordinates2;
  }

  Future<MetersToMarkers> metersToMarkers(double _currentMarkerLat,
      double _currentMarkerLot, Map<String, LatLng> nearestStation) async {
    double distanceBetweenLocationAndStation;
    double distanceBetweenMarkerAndStation;
    _locationData = await location.getLocation();

    nearestStation.forEach((key, value) {
      distanceBetweenLocationAndStation = Geolocator.distanceBetween(
          _currentMarkerLat,
          _currentMarkerLot,
          value.latitude,
          value.longitude);
    });
    nearestStation.forEach((key, value) {
      distanceBetweenMarkerAndStation = Geolocator.distanceBetween(
          _locationData.latitude,
          _locationData.longitude,
          value.latitude,
          value.longitude);
    });

    int getDistanceLocSta = distanceBetweenLocationAndStation.toInt();
    int getDistanceMarkSta = distanceBetweenMarkerAndStation.toInt();

    return MetersToMarkers(
        metersFromLocationToStation: getDistanceLocSta,
        metersFromStationToDestination: getDistanceMarkSta);
  }
}
