import 'package:copenhagen_nature_explorer/repository/database_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:copenhagen_nature_explorer/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepo {
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference databaseRef =
      FirebaseFirestore.instance.collection("users");
  // final CollectionReference databaseRef =
  //     Firestore.instance.collection("users");
  AuthRepo();

  // Future<void> signInWithGoogle() async {
  //   final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //       idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

  //   final FirebaseUser user =
  //       (await _auth.signInWithCredential(credential)).user;
  //   print("User is signed in " + user.displayName);
  //   return user;
  // }

  Future<UserModel> registerEmailAndPassword(
      {String email, String password, String displayName}) async {
    final UserCredential newUser = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (newUser != null) {
      await FirebaseRepo(uid: newUser.user.uid).createUserAccount(displayName);
      print("Success");
    } else {
      print("User havent been created....");
    }
  }

  Future<UserModel> signInWithEmailAndPassword(
      {String email, String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    return getUser();
  }

  Future<UserModel> getUser() async {
    var firebaseUser = await _auth.currentUser;
    var userName =
        await FirebaseRepo(uid: firebaseUser.uid).getUserDisplayName();
    print(userName);
    return UserModel(uid: firebaseUser.uid, displayName: userName);
  }

  Future<bool> validatePassword(String password) async {
    var firebaseUser = await _auth.currentUser;

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

  Future<void> updatePassword(String password) async {
    var firebaseUser = await _auth.currentUser;
    firebaseUser.updatePassword(password);
  }
}
