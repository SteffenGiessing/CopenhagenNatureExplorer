import 'package:copenhagen_nature_explorer/repository/firestore_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:copenhagen_nature_explorer/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Collection reference to Users in database.
  final CollectionReference databaseRef =
      FirebaseFirestore.instance.collection("users");
  /*
    Registration provided by auth package.
    error handling for the future.
  */
  Future registerEmailAndPassword(
      {String email, String password, String displayName}) async {
    final UserCredential newUser = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (newUser != null) {
      await FirestoreRepo(uid: newUser.user.uid).createUserAccount(displayName);
    } else {
      Error();
    }
  }
  /*
    The sign in method provided by the auth package
  */
  Future<UserModel> signInWithEmailAndPassword(
      {String email, String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    return getUser();
  }
  /*
    line await FirestoreRepo there should be created a solution where instead the locator is being used
    I am quite aware how to achive it but because of time pressure i have decided not to improve further on the project
    and only write comments to the code.
  */
  Future<UserModel> getUser() async {
    var firebaseUser = _auth.currentUser;
    var userName =
        await FirestoreRepo(uid: firebaseUser.uid).getUserDisplayName();
    return UserModel(uid: firebaseUser.uid, displayName: userName);
  }
}
