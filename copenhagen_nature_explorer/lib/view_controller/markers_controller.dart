import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copenhagen_nature_explorer/repository/database_repo.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:copenhagen_nature_explorer/repository/storage_repo.dart';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/models/markersModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkersController {
  MarkerCreator _markerCreator;

  StorageRepo _storageRepo = locator.get<StorageRepo>();
  FirebaseRepo _firebaseRepo = locator.get<FirebaseRepo>();

  Future<HashMap<String, LatLng>> createMarkers() async {
    return await _firebaseRepo.getUserPost();
  }

  Future<MarkerCreator> getMarkerInfo({String key}) async {
    Map<String, String> fetchedMarkerInfo = new HashMap<String, String>();
    print(key);
    fetchedMarkerInfo = await _firebaseRepo.getMarkerInfo(key);
    fetchedMarkerInfo.forEach((key, value) {
      if (key == "displayName") {
        _markerCreator.displayName = value;
        print(_markerCreator.displayName);
      } else if (key == "infoText") {
        _markerCreator.infoText = value;
        print(_markerCreator.infoText);
      } else if (key == "downloadUrl") {
        _markerCreator.pictureUrl  = value;
      }
      
    });
      return _markerCreator;
  }
}
