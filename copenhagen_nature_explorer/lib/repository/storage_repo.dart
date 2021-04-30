import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/models/userModel.dart';
import 'package:copenhagen_nature_explorer/repository/auth_repo.dart';

class StorageRepo {
  firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instanceFor(
          bucket: "gs://copenhagennatureexplorer.appspot.com/");
  AuthRepo _authRepo = locator.get<AuthRepo>();

  Future<String> uploadFile(File file) async {
    UserModel user = await _authRepo.getUser();
    var userId = user.uid;

    var storageRef = _storage.ref().child("user/profile/$userId");
    var uploadTask = storageRef.putFile(file);
    var completedTask = await uploadTask;
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

  Future<String> uploadPostImage(File image, String imageName) async {
    //Google Storage have been giving me a lot of problems and i can see
    //that on googles offical docs there has been complained regarding the issue
    /*
  ->The putFile() function never returns so if you call await which is best practice.
    it won't return anything which means it will never continue the execution i have therefore
    cheated and added my self a wait for 5 seconds which insures that the picture have been stored
    this approach is not the best and not correct. It has been used only for making it function.
    ------ Desired approach --------
    var storageRef = _storage.ref().child("user/users/$imageName");
    var uploadTask = storageRef.putFile(file);
    var completedTask = await uploadTask;
    String downloadUrl = await completedTask.ref.getDownloadURL();
    return downloadUrl;
    */
    _storage.ref().child("user/post/$imageName").putFile(image);
    sleep(const Duration(seconds: 5));
    var downloadUrl =
        _storage.ref().child("user/post/$imageName").getDownloadURL();
    return downloadUrl;
  }

  Future<String> getMarkerPicture(String downloadUrl) async {
    try {
      return await _storage.ref().child("user/post/$downloadUrl").getDownloadURL();
    } catch (Exception) {
      print("No picture found");
    }
  }
}
