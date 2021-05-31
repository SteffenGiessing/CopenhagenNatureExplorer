import 'package:copenhagen_nature_explorer/repository/database_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:copenhagen_nature_explorer/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference to Users in database.
  final CollectionReference databaseRef =
      FirebaseFirestore.instance.collection("users");

  AuthRepo();
  //Register with Email and Password
  Future registerEmailAndPassword(
      {String email, String password, String displayName}) async {
    final UserCredential newUser = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (newUser != null) {
      await FirebaseRepo(uid: newUser.user.uid).createUserAccount(displayName);
    } else {
      Error();
    }
  }
  //Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword(
      {String email, String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    return getUser();
  }
  // Get User
  Future<UserModel> getUser() async {
    var firebaseUser =  _auth.currentUser;
    var userName =
        await FirebaseRepo(uid: firebaseUser.uid).getUserDisplayName();
    return UserModel(uid: firebaseUser.uid, displayName: userName);
  }
  //Validate password for user upon login.
  Future<bool> validatePassword(String password) async {
    var firebaseUser =  _auth.currentUser;

    var authCredentials = EmailAuthProvider.credential(
        email: firebaseUser.email, password: password);

    try {
      var authResult =
          await firebaseUser.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
