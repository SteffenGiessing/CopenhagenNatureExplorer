import 'dart:async';
import 'package:copenhagen_nature_explorer/model/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import './provider/user_places.dart';
import './screens/feed.dart';
import './screens/add_place.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => Place(),
      child: MaterialApp(
        title: "Find you adventure",
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.lightGreenAccent
          ),
        home: PlacesListScreen(),
        routes: {
          AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
        },
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   final CameraPosition _initialPosition = CameraPosition(target: LatLng(55.704212, 12.530581));
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         initialCameraPosition: _initialPosition,
//         mapType: MapType.normal,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: Icon(Icons.zoom_out),
//       ),
//     );
//   }
// }

// // class MapSampleState extends State<MapSample> {
// //   Completer<GoogleMapController> _controller = Completer();

// //   static final CameraPosition _kGooglePlex = CameraPosition(
// //     target: LatLng(37.42796133580664, -122.085749655962),
// //     zoom: 14.4746,
// //   );

// //   static final CameraPosition _kLake = CameraPosition(
// //       bearing: 192.8334901395799,
// //       target: LatLng(37.43296265331129, -122.08832357078792),
// //       tilt: 59.440717697143555,
// //       zoom: 19.151926040649414);

// //   @override
// //   Widget build(BuildContext context) {
// //     return new Scaffold(
// //       body: GoogleMap(
// //         mapType: MapType.normal,
// //         initialCameraPosition: _kGooglePlex,
// //         onMapCreated: (GoogleMapController controller) {
// //           _controller.complete(controller);
// //         },
// //       ),
// //       floatingActionButton: FloatingActionButton.extended(
// //         onPressed: _goToTheLake,
// //         label: Text("To The Lake"),
// //         icon: Icon(Icons.directions_boat),
// //       ),
// //     );
// //   }

// //   Future<void> _goToTheLake() async {
// //     final GoogleMapController controller = await _controller.future;
// //     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
// //   }
// // }
