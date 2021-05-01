import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/models/markersModel.dart';
import 'package:copenhagen_nature_explorer/models/place.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class FirebaseRepo {
  final String uid;
  FirebaseRepo({this.uid});

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
    int incrementor = 0;
    double lat;
    double lot;
    var snapshot = await firestorePost.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((element) async {
        incrementor++;
        String newIncroment = incrementor.toString();
        // Map<double, double> values;
        // values.addAll(element["latitude"].toDouble());
        // values.addAll(element["longitude"].toDouble());
        // print(values.toString());
        // print(element.data());
        // final getJsonObject = element.data();
        // Map mapValue = jsonDecode(getJsonObject);
        lat = double.parse(element["latitude"].toString());
        lot = double.parse(element["longitude"].toString());
        print("$lat + $lot");
        // lat = element.data()
        //  = json.decode(element["latitude"]);
        //var lot = json.decode.parseDouble(element["longitude"].parseDouble());
        // LatLng latLot = await convertLatLng(lat, lot);
        final LatLng latlot = new LatLng(lat, lot);

        listLatLng[element.id] = latlot;
        print(listLatLng);
      });
    });
    return listLatLng;
  }

  Future<LatLng> convertLatLng(double lat, double lot) async {
    final LatLng latlot = new LatLng(lat, lot);

    return latlot;
  }

  Future<MarkerCreator> getMarkerInfo(String key) async {
    HashMap<String, String> markerInfo = new HashMap<String, String>();
    String displayName;
    String infoText;
    String downloadUrl;
    var snapshot =
        await firestorePost.doc(key).get().then((querySnapshot) async {
      displayName = querySnapshot["displayName"];
      infoText = querySnapshot["infoText"];
      downloadUrl = querySnapshot["downloadUrl"];
      // for (var key in querySnapshot.data().keys) {
      //   if (key == "displayName") {
      //     String displayName = querySnapshot["displayName"];
      //     markerInfo[key] = displayName;
      //   } else if (key == "infoText") {
      //     String infoText = querySnapshot["infoText"];
      //     markerInfo[key] = infoText;
      //   } else if (key == "downloadUrl") {
      //     String downloadUrl = querySnapshot["downloadUrl"];
      //     markerInfo[key] = downloadUrl;
      //   }
      // }
      print(displayName + ": " + infoText + ": " + downloadUrl);
    });
    return MarkerCreator(
        displayName: displayName, infoText: infoText, pictureUrl: downloadUrl);
  }
}
