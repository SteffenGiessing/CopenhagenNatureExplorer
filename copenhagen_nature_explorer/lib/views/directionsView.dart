import 'dart:async';
import 'package:copenhagen_nature_explorer/models/metersToMarkers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:copenhagen_nature_explorer/models/markersModel.dart';
import 'package:copenhagen_nature_explorer/view_controller/markers_controller.dart';
import 'package:copenhagen_nature_explorer/locator.dart';

class DirectionsView extends StatefulWidget {
  static String route = "directions";

  @override
  _DirectionsViewState createState() => _DirectionsViewState();
}

class _DirectionsViewState extends State<DirectionsView> {
  
  NearestStation _nearestStation =
      locator.get<MarkersController>().nearestStation;
  Set<Marker> markers = new Set();

  List<LatLng> polyLinesCoordinates1 = [];
  List<LatLng> polyLinesCoordinates2 = [];

  TextEditingController _distanceStationToDestination = TextEditingController();
  TextEditingController _distanceLocationToStation = TextEditingController();
  String getAsString;

  final Set<Polyline> _polyline = {};
  GoogleMapController controller;

  var gettingMarkers;
  var getDistance;

  @override
  void initState() {
    super.initState();
    _onMapCreated(controller);
    _setUpDistance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explorer"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        child: new Column(
          children: [
            new Container(
              height: 630,
              width: double.infinity,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(55.7046696, 12.5314824), zoom: 13),
                onMapCreated: _onMapCreated,
                markers: Set.of(markers),
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                polylines: Set.of(_polyline),
              ),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                ListTile(
                  title: Text("Blueline: Distance to marker.  " + _distanceLocationToStation.text + " M"),
                  subtitle: Text("Redline: Distance to marker.  " + _distanceStationToDestination.text + " M"),
                ),     
              ],
            ),
          ],
        ),
      ),
    );
  }
  //Setup Map
  Future _onMapCreated(GoogleMapController controllerParam) async {
    
    //Call getClosestStation and create markers.
    gettingMarkers = await MarkersController().getClosestStation();

    //Create List to feed into polyLine which contains the coordinates between the markers
    List<LatLng> latLineOne = await MarkersController()
        .userLocationToStation(_nearestStation.nearestStation);

    //Create List to feed into polyLine which contains the coordinates between the markers
    List<LatLng> latLineTwo = await MarkersController()
        .stationToDestination(_nearestStation.nearestStation);
    //Create the values between each markers in meters.
    _setUpDistance();

    //SetState for Markers and Polylines on Map
    setState(() {
      //Goole Map controller
      controller = controllerParam;
      //First PolyLine -> User Location to Station
      _polyline.add(Polyline(
        polylineId: PolylineId('Location to Station.'),
        visible: true,
        points: latLineOne,
        width: 2,
        color: Colors.blue,
      ));

      _polyline.add(Polyline(
        polylineId: PolylineId('Station to Destination.'),
        visible: true,
        points: latLineTwo,
        width: 2,
        color: Colors.red,
      ));

      markers.addAll(gettingMarkers);
    });
  }

  Future _setUpDistance() async {

    MetersToMarkers _metersToMarkers =
        await MarkersController().setupMetersToMarkers();

    setState(() {
      _distanceLocationToStation.text =
          _metersToMarkers.metersFromLocationToStation.toString();

      _distanceStationToDestination.text =
          _metersToMarkers.metersFromStationToDestination.toString();
    });
  }
}
