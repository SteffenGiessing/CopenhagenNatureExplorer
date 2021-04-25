import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/models/userModel.dart';
import 'package:copenhagen_nature_explorer/repository/auth_repo.dart';

class StorageRepo {
  FirebaseStorage _storage = FirebaseStorage(
      storageBucket: "gs://copenhagennatureexplorer.appspot.com/");
  AuthRepo _authRepo = locator.get<AuthRepo>();

  Future<String> uploadFile(File file) async {
    UserModel user = await _authRepo.getUser();
    var userId = user.uid;

    var storageRef = _storage.ref().child("user/profile/$userId");
    var uploadTask = storageRef.putFile(file);
    var completedTask = await uploadTask.onComplete;
    String downloadUrl = await completedTask.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> getUserProfileImage(String uid) async {
    try {
      return await _storage.ref().child("user/profile/$uid").getDownloadURL();
    } catch (Exception) {
      print("No picture found");
    }
  }
}