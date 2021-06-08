import 'dart:io';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copenhagen_nature_explorer/models/markersModel.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:copenhagen_nature_explorer/views/homeView.dart';

class FirebaseRepo {
  final String uid;
  FirebaseRepo({this.uid});
  HomeView _homeView = new HomeView();
  firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instanceFor(
          bucket: "gs://copenhagennatureexplorer.appspot.com/");

  CollectionReference firestore =
      FirebaseFirestore.instance.collection("users");

  CollectionReference firestorePost =
      FirebaseFirestore.instance.collection("user posts");

  Future createUserAccount(String displayName) async {
    return await firestore.doc(uid).set({
      "displayName": displayName,
    });
  }

  Future getUserDisplayName() async {
    String displayName;
    await firestore.doc(uid).get().then((snapShot) {
      displayName = snapShot["displayName"].toString();
    });
    return displayName;
  }

  Future<void> addPost(
      {String uid,
      File image,
      String displayName,
      String infoText,
      double latitude,
      double longitude,
      String imageUrl}) async {
    await firestorePost.doc().set({
      "uid": uid,
      "displayName": displayName,
      "infoText": infoText,
      "latitude": latitude,
      "longitude": longitude,
      "downloadUrl": imageUrl,
    });
  }

  Future<HashMap<String, LatLng>> getUserPost() async {
    Map<String, LatLng> listLatLng = new HashMap<String, LatLng>();
    double lat;
    double lot;
    var snapshot = await firestorePost.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((element) async {
        lat = double.parse(element["latitude"].toString());
        lot = double.parse(element["longitude"].toString());
        final LatLng latlot = new LatLng(lat, lot);
        listLatLng[element.id] = latlot;
        print(element.id);
      });
    });
    return listLatLng;
  }

  // Future<LatLng> convertLatLng(double lat, double lot) async {
  //   final LatLng latlot = new LatLng(lat, lot);

  //   return latlot;
  // }

  Future<MarkerCreator> getMarkerInfo(String key) async {
    String displayName;
    String infoText;
    String downloadUrl;
    double lat;
    double lot;
    var snapshot =
        await firestorePost.doc(key).get().then((querySnapshot) async {
      displayName = querySnapshot["displayName"];
      infoText = querySnapshot["infoText"];
      downloadUrl = querySnapshot["downloadUrl"];
      lat = double.parse(querySnapshot["latitude"].toString());
      lot = double.parse(querySnapshot["longitude"].toString());
    });
    return MarkerCreator(
        displayName: displayName,
        infoText: infoText,
        pictureUrl: downloadUrl,
        latitude: lat,
        longitude: lot);
  }
}
