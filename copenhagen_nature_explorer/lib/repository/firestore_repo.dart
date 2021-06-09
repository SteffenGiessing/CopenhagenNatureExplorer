import 'dart:io';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copenhagen_nature_explorer/models/markersModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirestoreRepo {
  final String uid;
  FirestoreRepo({this.uid});

  CollectionReference firestore =
      FirebaseFirestore.instance.collection("users");

  CollectionReference firestorePost =
      FirebaseFirestore.instance.collection("user posts");

  CollectionReference firestoreStations =
      FirebaseFirestore.instance.collection("trainStations");

  /*
    Create user and give them the uid and a displayname.
  */
  Future createUserAccount(String displayName) async {
    return await firestore.doc(uid).set({
      "displayName": displayName,
    });
  }
  /*
    Getting userDisplayName.
  */
  Future getUserDisplayName() async {
    String displayName;
    await firestore.doc(uid).get().then((snapShot) {
      displayName = snapShot["displayName"].toString();
    });
    return displayName;
  }

  /*
    Add post to the firestore.
  */
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

  //Getting user posts. Storing it in a 
  //hashmap with key as documentation ref and the coordinates as value.
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
      });
    });
    return listLatLng;
  }

  /*
    Getting information about the marker that user have clicked.
  */
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
