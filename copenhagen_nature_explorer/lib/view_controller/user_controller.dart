import 'package:copenhagen_nature_explorer/locator.dart';
import 'package:copenhagen_nature_explorer/models/userModel.dart';
import 'package:copenhagen_nature_explorer/repository/auth_repo.dart';

class UserController {
  UserModel _currentUser;
  
  AuthRepo _authRepo = locator.get<AuthRepo>();
  
  Future init;

  UserController() {
    init = initUser();
  }

  Future<UserModel> initUser() async {
    _currentUser = await _authRepo.getUser();
    return _currentUser;
  }

  UserModel get currentUser => _currentUser;

  // Get information about the user
  Future<UserModel> getUserInfo() async {
    return await _authRepo.getUser();
  }
  // Register user
  Future<void> registerEmailAndPassword(
      {String email, String password, String displayName}) async {
    _currentUser = await _authRepo.registerEmailAndPassword(
        email: email, password: password, displayName: displayName);
    _authRepo.getUser();
  }
  // Sign in with Email and Password
  Future<void> signInWithEmailAndPassword(
      {String email, String password}) async {
    _currentUser = await _authRepo.signInWithEmailAndPassword(
        email: email, password: password);
    //_currentUser.avatarUrl = await getDownloadUrl();
  }
  //Validating user when logging in
  Future<bool> validateCurrentPassword(String password) async {
    return await _authRepo.validatePassword(password);
  }

 
}
