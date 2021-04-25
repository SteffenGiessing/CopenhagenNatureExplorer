import 'dart:io';
import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/models/userModel.dart';
import 'package:copenhagen_nature_explorer/repository/auth_repo.dart';
import 'package:copenhagen_nature_explorer/repository/storage_repo.dart';

class UserController {
  UserModel _currentUser;
  AuthRepo _authRepo = locator.get<AuthRepo>();
  StorageRepo _storageRepo = locator.get<StorageRepo>();
  Future init;

  UserController() {
    init = initUser();
  }

  Future<UserModel> initUser() async {
    _currentUser = await _authRepo.getUser();
    return _currentUser;
  }

  UserModel get currentUser => _currentUser;

  Future<void> uploadProfilePicture(File image) async {
    _currentUser.avatarUrl = await _storageRepo.uploadFile(image);
  }

  Future<String> getDownloadUrl() async {
    return await _storageRepo.getUserProfileImage(currentUser.uid);
  }

  Future<UserModel> getUserInfo() async {
    return await _authRepo.getUser();
  }

  Future<void> registerEmailAndPassword(
      {String email, String password, String displayName}) async {
    _currentUser = await _authRepo.registerEmailAndPassword(
        email: email, password: password, displayName: displayName);
  }

  Future<void> signInWithEmailAndPassword(
      {String email, String password}) async {
    _currentUser = await _authRepo.signInWithEmailAndPassword(
        email: email, password: password);
    _authRepo.getUser();
    _currentUser.avatarUrl = await getDownloadUrl();
  }

  void updateDisplayName(String displayName) {
    _currentUser.displayName = displayName;
    _authRepo.updatePassword(displayName);
  }

  Future<bool> validateCurrentPassword(String password) async {
    return await _authRepo.validatePassword(password);
  }

  void updateUserPassword(String password) {
    _authRepo.updatePassword(password);
  }
}
