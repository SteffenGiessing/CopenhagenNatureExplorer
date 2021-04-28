import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:copenhagen_nature_explorer/repository/storage_repo.dart';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/models/markersModel.dart';

class MarkersController {
  MarkerCreator _markerCreator;

  StorageRepo _storageRepo = locator.get<StorageRepo>();

  
  Future<void> createMarkers() {
    
  }



  

}
