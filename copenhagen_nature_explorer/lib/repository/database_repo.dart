import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'dart:io';

class FirebaseRepo {
  final String uid;
  FirebaseRepo({this.uid});

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
      String displayName,
      String infoText,
      double latitude,
      double longitude}) async {
    await firestorePost.doc(uid).set({
      "uid": uid,
      "displayName": displayName,
      "infoText": infoText,
      "latitude": latitude,
      "longitude": longitude,
    });
  
  }
}
