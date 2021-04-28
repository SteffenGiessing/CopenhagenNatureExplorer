import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

import 'package:flutter/services.dart';

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

  Future getUserPost() async {
    var snapshot = await firestorePost.doc().get();
    return print(snapshot.data());
  }
}
