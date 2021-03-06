import 'dart:async';
import 'package:copenhagen_nature_explorer/view_controller/markers_controller.dart';
import 'package:copenhagen_nature_explorer/views/addpostView.dart';
import 'package:copenhagen_nature_explorer/views/directionsView.dart';
import 'package:copenhagen_nature_explorer/models/markersModel.dart';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:copenhagen_nature_explorer/models/polygonMapModel.dart';

class HomeView extends StatefulWidget {
  static String route = "home";

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Set<Marker> markers = new Set();
  Completer<GoogleMapController> _controller = Completer();
  final picker = ImagePicker();
  MarkerCreator markerCreator = MarkerCreator();

  @override
  void initState() {
    super.initState();
    callMarkers();
    polygonMap();
  }
  /*
  The initState from above should not call internally inside the class but call out of the class to a controller
  Like with the polygonMap.
  */
  void callMarkers() async {
    Map<String, LatLng> fetchedMarkers =
        await locator.get<MarkersController>().createMarkers();
    _createMarker(fetchedMarkers);
  }
 /*
  Fetching markers solution need to found so we can move this park out of the homeview.
  I would like to create a solution where only 
  setStat(() {
     markers.add(resultMarker);
  )})
  Is being done in the view.
  */
  void _createMarker(Map<String, LatLng> fetchedMarkers) {
    fetchedMarkers.forEach((key, value) {
      Marker resultMarker = Marker(
          markerId: MarkerId(key),
          position: LatLng(value.latitude, value.longitude),
          onTap: () async {
            await locator.get<MarkersController>().getMarkerInfo(key: key);
            showAddPost(markerCreator);
          });
      setState(() {
        markers.add(resultMarker);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explorer"),
        actions: <Widget>[],
      ),
      body: GoogleMap(
        polygons: polygonMap(),
        initialCameraPosition:
            CameraPosition(target: LatLng(55.7046696, 12.5314824), zoom: 13),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.of(markers),
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.pushNamed(context, AddPostView.route);
        },
        icon: Icon(Icons.add),
        backgroundColor: Colors.green,
        label: const Text("Add New Post"),
      ),
    );
  }

  void showAddPost(MarkerCreator markerCreator) {
    var textTheme = Theme.of(context).textTheme;
    MarkerCreator _currentMarker = locator.get<MarkersController>().marker;
    showGeneralDialog(
      barrierLabel: "Barrier",
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: Image.network(
                      _currentMarker.pictureUrl,
                      height: 170,
                      fit: BoxFit.fill,
                    ),
                  ),
                  ListTile(
                    title: Text("Description:  " + _currentMarker.infoText),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("User:  " + _currentMarker.displayName),
                          ElevatedButton.icon(
                              icon: Icon(Icons.arrow_forward_outlined,
                                  color: textTheme.button.color),
                              label: Text(
                                "Get Directions",
                                style: textTheme.button,
                              ),
                              onPressed: () async {
                                await Navigator.pushNamed(
                                  context,
                                  DirectionsView.route,
                                );
                              }),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
