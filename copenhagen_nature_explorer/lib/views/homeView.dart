import 'dart:async';
import 'package:copenhagen_nature_explorer/view_controller/markers_controller.dart';
import 'package:copenhagen_nature_explorer/views/addpostView.dart';
import 'package:copenhagen_nature_explorer/views/profileView.dart';
import 'package:copenhagen_nature_explorer/repository/maps_repo.dart';
import 'package:copenhagen_nature_explorer/models/place.dart';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:copenhagen_nature_explorer/models/markersModel.dart';

class HomeView extends StatefulWidget {
  static String route = "home";
  final LocationAttributes starterLocation;
  //55.6837
  HomeView(
      [this.starterLocation = const LocationAttributes(
          latitude: 45.521563, longitude: -122.677433)]);
  //55.6837
  //12.5716
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Set<Marker> markers = new Set();
  Completer<GoogleMapController> _controller = Completer();
  final picker = ImagePicker();
  MarkerCreator markerCreator = MarkerCreator();

  // final locData = await Location().getLocation();
  @override
  void initState() {
    super.initState();
    callMarkers();
    _getCurrentLocation();

    //sleep(const Duration(seconds: 5));
  }

  void callMarkers() async {
    Map<String, LatLng> fetchedMarkers =
        await locator.get<MarkersController>().createMarkers();
    _createMarker(fetchedMarkers);
  }

  Future<void> _getCurrentLocation() async {
    final staticMapImageUrl = LocationFinder.generateLocation(
        latitude: 12.57160, longitude: 55.68332);
  }

  Marker _createMarker(Map<String, LatLng> fetchedMarkers) {
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

  Set<Polygon> polygonMap() {
    List<LatLng> polygonCordinats = new List();
    polygonCordinats.add(LatLng(55.50800858787899, 12.640172797687912));
    polygonCordinats.add(LatLng(55.52433653086542, 12.843419868000412));
    polygonCordinats.add(LatLng(56.050165460787206, 12.651159125812912));
    polygonCordinats.add(LatLng(56.192552238039255, 12.299596625812912));
    polygonCordinats.add(LatLng(56.03789250931526, 11.851903754719162));
    polygonCordinats.add(LatLng(55.76844367599267, 11.755773383625412));
    polygonCordinats.add(LatLng(55.582595328478334, 11.781865912922287));
    polygonCordinats.add(LatLng(55.582595328478334, 11.781865912922287));
    polygonCordinats.add(LatLng(55.402101637563305, 11.873876410969162));
    polygonCordinats.add(LatLng(55.26462312215679, 12.02699835921135));
    polygonCordinats.add(LatLng(55.2333114533373, 12.443792182453537));
    polygonCordinats.add(LatLng(55.43951303319231, 12.574254828937912));
    polygonCordinats.add(LatLng(55.50270219979265, 12.651159125812912));

    Set<Polygon> polygonSet = new Set();
    polygonSet.add(Polygon(
        polygonId: PolygonId("Testing"),
        points: polygonCordinats,
        fillColor: (Color.fromARGB(0, 0, 0, 0)),
        strokeColor: Colors.lightGreen,
        strokeWidth: 1));

    return polygonSet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explorer"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.account_box_sharp),
              onPressed: () {
                Navigator.pushNamed(context, ProfileView.route);
              }),
        ],
      ),
      body: GoogleMap(
        polygons: polygonMap(),
        initialCameraPosition:
            CameraPosition(target: LatLng(55.7046696, 12.5314824), zoom: 13),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          Set.of(markers);
        },
        markers: Set.of(markers),
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await locator.get<MarkersController>().createMarkers();
          Navigator.pushNamed(context, AddPostView.route);
        },
        icon: Icon(Icons.add),
        backgroundColor: Colors.green,
        label: const Text("Add New Post"),
      ),
    );
  }

  void showAddPost(MarkerCreator markerCreator) {
    MarkerCreator _currentMarker = locator.get<MarkersController>().markers;
    print("print " + _currentMarker.getDisplayName.toString());
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
            margin: EdgeInsets.only(bottom: 75, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(color: Colors.grey, width: 1)
            ),
            child: SizedBox.expand(
              
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  
                  new Text("Posted by: " +
                _currentMarker.displayName,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 10),
                ),
                  new Text("Comments: " + _currentMarker.infoText,
                  textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
                ),
              Image.network(
                _currentMarker.pictureUrl,
                alignment: Alignment.centerLeft,
              ),
          
              
              
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.stretch,                
                // TextFormField(
                // )
                // ),
                ],
              ),
            // margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            // decoration: BoxDecoration(
            //   color: Colors.green,
            // ),
            
            ),
          
          ),
          // child: Row(
          //     width: 10,
          //     height: 10,
          //     alignment: Alignment.topLeft,
          //     decoration: BoxDecoration(
          //       color: Color(0xBBFFFFFF),
          //       border: Border.all(color: Colors.grey, width: 1),
          //     ),
         
          
        );
      },
    );
  }
}

// GoogleMapController _controller;
// final CameraPosition _cameraPosition = CameraPosition(
//   target: LatLng(45.521563, -122.677433),
//   zoom: 16,
// );

// Future<void> _SelectOnMap() async {
//   Navigator.of(context).puhs(MaterialPageRoute(builder: (ctx)))
// }
//   ElevatedButton.icon(
//   onPressed: () async {
//     final image =
//         await picker.getImage(source: ImageSource.camera);

//   },
//   icon: Icon(Icons.add_a_photo),
//   label: Text("Add A Photo"),
// ),
// ElevatedButton.icon(
//   onPressed: () {},
//   icon: Icon(Icons.photo_library_rounded),
//   label: Text("Pick From Gallery"),
//   ),
// Future <String> _setStyle(GoogleMapController controller) async {
//   String value = controller.(Color.fromARGB(255, 255, 255, 255));
//   return value;
// }
// floatingActionButton: Container(
//   child: Align(
//     alignment: Alignment.bottomCenter,
//     child: FloatingActionButton.extended(
//       icon: Icon(Icons.add),
//       onPressed: () {
//         Navigator.pushNamed(context, ExplorerView.route);
//       },
//     ),
//   ),
// ),
// children: GoogleMap(
//     mapType: MapType.normal,
//     initialCameraPosition: _cameraPosition,
// onMapCreated: (GoogleMapController controller) {
//   _controller.complete(controller);
// },
// ),
// body: Image.network(
//   _previewImageUrl,
//   fit: BoxFit.cover,
//   width: double.infinity,
//   height: double.infinity,
//
// List<LatLng> polygonCordinats = new List();
// polygonCordinats.add(LatLng(    55.352208849796526, 12.616716440848244));
// polygonCordinats.add(LatLng(55.59156128627027, 12.839189585379494));
// polygonCordinats.add(LatLng(55.886498533136894, 12.789751108816994));
// polygonCordinats.add(LatLng(56.11801311252907, 12.635942515066994));
// polygonCordinats.add(LatLng(56.16812313231777, 12.212968882254334));
// polygonCordinats.add(LatLng(56.4072923743333, 11.664656227586665));
// polygonCordinats.add(LatLng(56.503586401025814, 12.27489931431525));
// polygonCordinats.add(LatLng(56.43902906371402, 13.022471502606336));
// polygonCordinats.add(LatLng(56.06334172481842, 13.45294580264592));
// polygonCordinats.add(LatLng(55.66382309378222, 13.768063657372842));
// polygonCordinats.add(LatLng(55.23513394834766, 13.467947137099845));
// polygonCordinats.add(LatLng(55.0955041169383, 13.088918816787345));
// polygonCordinats.add(LatLng(55.05619424742141, 12.600027215224845));
// polygonCordinats.add(LatLng(55.042033237422466, 12.231985223037345));
// polygonCordinats.add(LatLng(55.053047789060756, 11.726614129287345));
// polygonCordinats.add(LatLng(55.268009046361605, 11.207510125381095));
// polygonCordinats.add(LatLng(55.69291561351123, 11.034475457412185));
// polygonCordinats.add(LatLng(56.34651224109547, 11.218220622725));
// polygonCordinats.add(LatLng(56.40566311055311, 11.667148869443906));
// polygonCordinats.add(LatLng(56.176858621732706, 12.203967741162813));
// polygonCordinats.add(LatLng(55.99998539871754, 11.816203377998233));
// polygonCordinats.add(LatLng(55.92102793297449, 11.816765949316483));
// polygonCordinats.add(LatLng(55.84190930201156, 11.866766997197153));
// polygonCordinats.add(LatLng(55.65840500638717, 11.895357960146153));
// polygonCordinats.add(LatLng(55.52887216393642, 11.895109811767028));
// polygonCordinats.add(LatLng(55.38331155947654, 12.032190764950323));
// polygonCordinats.add(LatLng(55.341190194454924, 12.138496744471698));
// polygonCordinats.add(LatLng(55.32403388785155, 12.288748036492994));

// List<LatLng> polygonBlackOut = new List();
// polygonBlackOut.add(LatLng(-84.86481327950476, 178.2541223319496));
// polygonBlackOut.add(LatLng(-85.01360535043395, 0.6897837995877509));
// polygonBlackOut.add(LatLng(84.70318846237576, 0.35570785834138974));
// polygonBlackOut.add(LatLng(84.36852534431648, 177.54320785834136));
// polygonBlackOut.add(LatLng(-84.77335252903842, -176.1286671416586));
// polygonBlackOut.add(LatLng(-85.08402118312145, -9.48804214165861));
// polygonBlackOut.add(LatLng(84.89438945613134, -5.26929214165861));
// polygonBlackOut.add(LatLng(84.50484832492883, 178.94945785834136));

// Set<Polygon> polygonBlackOutSet = new Set();
// polygonBlackOut.add(Polygon(
//   polygonId: PolygonId("blackOut"),
//   points: polygonBlackOut,
//   fillColor: (Color.fromARGB(255, 255, 255,255)),
//   strokeColor: Colors.black
//   ));
/*
    #Polygon_0
55.352208849796526, 12.616716440848244
55.59156128627027, 12.839189585379494
55.886498533136894, 12.789751108816994
56.11801311252907, 12.635942515066994
56.16812313231777, 12.212968882254334
56.4072923743333, 11.664656227586665
56.503586401025814, 12.27489931431525
56.43902906371402, 13.022471502606336
56.06334172481842, 13.45294580264592
55.66382309378222, 13.768063657372842
55.23513394834766, 13.467947137099845
55.0955041169383, 13.088918816787345
55.05619424742141, 12.600027215224845
55.042033237422466, 12.231985223037345
55.053047789060756, 11.726614129287345
55.268009046361605, 11.207510125381095
55.69291561351123, 11.034475457412185
56.34651224109547, 11.218220622725
56.40566311055311, 11.667148869443906
56.176858621732706, 12.203967741162813
55.99998539871754, 11.816203377998233
55.92102793297449, 11.816765949316483
55.84190930201156, 11.866766997197153
55.65840500638717, 11.895357960146153
55.52887216393642, 11.895109811767028
55.38331155947654, 12.032190764950323
55.341190194454924, 12.138496744471698
55.32403388785155, 12.288748036492994
*/

// Set<Polygon> blackOutMap() {
//   List<LatLng> polygonBlackOut = new List();
//   polygonBlackOut.add(LatLng(-84.86481327950476, 178.2541223319496));
//   polygonBlackOut.add(LatLng(-85.01360535043395, 0.6897837995877509));
//   polygonBlackOut.add(LatLng(84.70318846237576, 0.35570785834138974));
//   polygonBlackOut.add(LatLng(84.36852534431648, 177.54320785834136));
//   polygonBlackOut.add(LatLng(-84.77335252903842, -176.1286671416586));
//   polygonBlackOut.add(LatLng(-85.08402118312145, -9.48804214165861));
//   polygonBlackOut.add(LatLng(84.89438945613134, -5.26929214165861));
//   polygonBlackOut.add(LatLng(84.50484832492883, 178.94945785834136));

//   Set<Polygon> polygonBlackOutSet = new Set();
//   polygonBlackOut.add(Polygon(
//     polygonId: PolygonId("blackOut"),
//     points: polygonBlackOut,
//     fillColor: (Color.fromARGB(255, 255, 255,255)),
//     strokeColor: Colors.black
//     ));

//   return polygonBlackOutSet;
//}

// ),

// void _showDialog() async {
//   return showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("AlertDialog"),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('This is a demo alert dialog.'),
//                 Text('Would you like to approve of this message?'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Approve"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             )
//           ],
//         );
//       });
// }
