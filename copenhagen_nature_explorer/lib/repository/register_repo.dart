// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:copenhagen_nature_explorer/models/userModel.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/material.dart';
// import 'package:copenhagen_nature_explorer/locator.dart';
// import 'package:get_it/get_it.dart';
// import 'package:copenhagen_nature_explorer/models/userModel.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:http/http.dart' as http;

// import 'package:copenhagen_nature_explorer/models/registerModel.dart';
// import 'package:path/path.dart';

// class RegisterRepo {
//   final GoogleSignIn _registerAccount = GoogleSignIn();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final databaseRef = FirebaseDatabase.instance.reference();
//   RegisterRepo();
//   Future<RegisterModel> registerEmailAndPassword(
//       {String email, String password, String displayName}) async {
//     final FirebaseUser newUser = (await _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     ))
//         .user;
//     if (newUser != null) {
//       var firebaseUser = await _auth.currentUser();
//       databaseRef
//           .push()
//           .set({"uid": firebaseUser.uid, "displayName": displayName});
//     } else {
//       print("User havent been created....");
//     }
//   }
// }
