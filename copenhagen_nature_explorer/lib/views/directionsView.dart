import 'dart:async';
import 'package:copenhagen_nature_explorer/models/markersModel.dart';
import 'package:copenhagen_nature_explorer/view_controller/markers_controller.dart';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsView extends StatefulWidget {
  static String route = "directions";

  @override
  _DirectionsViewState createState() => _DirectionsViewState();
}

class _DirectionsViewState extends State<DirectionsView> {
  //Markers and Polylines final list.
  final Set<Marker> markers = {};
  final Set<Polyline> _polyline = {};

  //Nearest Station
  NearestStation _nearestStation;

  //PolyLines
   List<LatLng> latLineOne;
   List<LatLng> latLineTwo;

  //Routes Lists
  List<String> transportRoute;
  List<String> transportWalking;

  //GoogleMapController.
  GoogleMapController controller;

  //Getting Markers.
  var gettingMarkers;

  //Building Route
  var builtTransitRoute;
  var builtWalkingRoute;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  //Init
  @override
  void initState() {
    super.initState();
    _onMapCreated(controller);
  }

  //Map View with a floating button
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Directions "),
      ),
      body: Container(
        child: new Column(
          children: [
            new Container(
              height: 708,
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          routeDetailsDialog();
        },
        icon: Icon(Icons.directions_transit_outlined),
        backgroundColor: Colors.green,
        label: const Text("See Complete Route"),
      ),
    );
  }

  //Opens Dialog with routes details.
  void routeDetailsDialog() {
    transportRoute = builtTransitRoute.transportTransit;
    transportWalking = builtWalkingRoute.transportWalking;
    showGeneralDialog(
        barrierLabel: "barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 450),
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondary) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    Divider(
                      color: Colors.blue,
                      thickness: 5,
                    ),
                    for (var i in transportRoute)
                      ListTile(
                        title: Text("$i \n"),
                        subtitle: Divider(
                          color: Colors.blue,
                          thickness: 2,
                        ),
                      ),
                    Divider(
                      color: Colors.red,
                      thickness: 5,
                    ),
                    for (var iw in transportWalking)
                      ListTile(
                        title: Text("$iw \n"),
                        subtitle: Divider(
                          color: Colors.red,
                          thickness: 2,
                        ),
                      ),
                  ]),
                ),
              ),
            ),
          );
        });
  }

  //Method: to setup Map.
  Future _onMapCreated(GoogleMapController controllerParam) async {
    //Locator Getter to recieve nearest station.
    _nearestStation = locator.get<MarkersController>().nearestStation;

    //Call getClosestStation and create markers.
    gettingMarkers = await locator.get<MarkersController>().getClosestStation();
    markers.addAll(gettingMarkers);
    
    //Create List to feed into polyLine which contains the coordinates between the markers.
    latLineOne = await locator
        .get<MarkersController>()
        .userLocationToStation(_nearestStation.nearestStation);
    print(latLineOne);
    //Create List to feed into polyLine which contains the coordinates between the markers.
    latLineTwo = await locator
        .get<MarkersController>()
        .stationToDestination(_nearestStation.nearestStation);

    //Building paramteres for polylines User Location To Station
    final locationToStation = await locator
        .get<MarkersController>()
        .getLocationToStation(
            location: latLineOne.first, station: latLineOne.last);

    //Building parameters for polyline Station to Destination
    final stationToDestination = await locator
        .get<MarkersController>()
        .getStationToDestination(
            station: latLineOne.last, destination: latLineTwo.last);

    //Creating paramteres for transit directions
    builtTransitRoute = await locator
        .get<MarkersController>()
        .builtRoute(latLineOne.first, latLineOne.last, "transit");

    //Creating paramteres for walking directions
    builtWalkingRoute = await locator
        .get<MarkersController>()
        .builtRoute(latLineTwo.first, latLineTwo.last, "walking");

    latLineOne.clear();
    latLineTwo.clear();
    //Setting first polyline -> LocationToStation
    _polyline.add(
      Polyline(
          polylineId: PolylineId("Location to Station"),
          visible: true,
          width: 2,
          color: Colors.blue,
          points: locationToStation),
    );

    //Setting second polyline -> stationToDestination
    _polyline.add(
      Polyline(
        polylineId: PolylineId("station to destination"),
        visible: true,
        width: 2,
        color: Colors.red,
        points: stationToDestination,
      ),
    );
    //SetState for Markers and Polylines on Map.
    setState(() {
    
      //Goole Map controller
      controller = controllerParam;
    });
  }
}
