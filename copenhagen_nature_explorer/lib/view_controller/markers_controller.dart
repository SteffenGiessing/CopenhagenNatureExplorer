import 'dart:collection';
import 'package:copenhagen_nature_explorer/repository/database_repo.dart';
import 'package:copenhagen_nature_explorer/repository/storage_repo.dart';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/models/markersModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkersController {
  MarkerCreator _markerCreator;

  StorageRepo _storageRepo = locator.get<StorageRepo>();
  FirebaseRepo _firebaseRepo = locator.get<FirebaseRepo>();
  MarkerCreator get markers => _markerCreator;

  Future<HashMap<String, LatLng>> createMarkers() async {
    return await _firebaseRepo.getUserPost();
  }

  Future<MarkerCreator> getMarkerInfo({String key}) async {
    print(key);
    _markerCreator = await _firebaseRepo.getMarkerInfo(key);
    return MarkerCreator(pictureUrl: _markerCreator.pictureUrl, displayName: _markerCreator.displayName, infoText: _markerCreator.infoText);
  }
}
