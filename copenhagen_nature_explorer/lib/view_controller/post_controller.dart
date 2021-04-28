import 'dart:io';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/models/userModel.dart';
import 'package:copenhagen_nature_explorer/repository/auth_repo.dart';
import 'package:copenhagen_nature_explorer/repository/database_repo.dart';
import 'package:copenhagen_nature_explorer/repository/storage_repo.dart';
import 'package:location/location.dart';

class PostController {
  UserModel _currentUser;
  Location location = new Location();
  LocationData _locationData;
  AuthRepo _authRepo = locator.get<AuthRepo>();
  Future init;
  StorageRepo _storageRepo = locator.get<StorageRepo>();

  FirebaseRepo _fireRepo = locator.get<FirebaseRepo>();
  // StorageRepo _storageRepo = locator.get<StorageRepo>();
  // FirebaseRepo _firebaseRepo = locator.get<FirebaseRepo>();

  PostController() {
    init = initUser();
  }

  Future<UserModel> initUser() async {
    _currentUser = await _authRepo.getUser();
    return _currentUser;
  }

  UserModel get currentUser => _currentUser;

  Future<UserModel> getUserInfo() async {
    return await _authRepo.getUser();
  }

  Future<void> createPost({String infoText, File image}) async {
    _currentUser = await _authRepo.getUser();
    String uid = _currentUser.uid;
    String displayName = _currentUser.displayName;
    _locationData = await location.getLocation();
    String fileNameCreator =
        "$displayName-${_locationData.latitude}-${_locationData.longitude}";
    String getImageUrl = await _storageRepo.uploadPostImage(image,fileNameCreator);
    await _fireRepo.addPost(
      uid: uid,
      image: image,
      displayName: displayName,
      infoText: infoText,
      latitude: _locationData.latitude,
      longitude: _locationData.longitude,
      imageUrl: getImageUrl,
    );
  }
}
