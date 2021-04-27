import 'dart:async';
import 'package:copenhagen_nature_explorer/views/addpostView.dart';
import 'package:copenhagen_nature_explorer/views/profileView.dart';
import 'package:flutter/material.dart';
import 'package:copenhagen_nature_explorer/repository/maps_repo.dart';
import 'package:copenhagen_nature_explorer/models/place.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';


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
  String _previewImageUrl;
  final picker = ImagePicker();

  // final locData = await Location().getLocation();
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final staticMapImageUrl = LocationFinder.generateLocation(
        latitude: 12.57160, longitude: 55.68332);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  // GoogleMapController _controller;
  // final CameraPosition _cameraPosition = CameraPosition(
  //   target: LatLng(45.521563, -122.677433),
  //   zoom: 16,
  // );

  // Future<void> _SelectOnMap() async {
  //   Navigator.of(context).puhs(MaterialPageRoute(builder: (ctx)))
  // }
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
      body: Image.network(
        _previewImageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AddPostView.route);
        },
        icon: Icon(Icons.add),
        backgroundColor: Colors.green,
        label: const Text("Add New Post"),
        // children: GoogleMap(
        //     mapType: MapType.normal,
        //     initialCameraPosition: _cameraPosition,
        // onMapCreated: (GoogleMapController controller) {
        //   _controller.complete(controller);
        // },
        // ),
      ),
    );
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
  }

  void showAddPost() {
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
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox.expand(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xBBFFFFFF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      child: Form(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType.text,
                            ),
                          ],
                        ),

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
                      ),
                    ),
                  ),
                ),
              ));
        });
  }
}
