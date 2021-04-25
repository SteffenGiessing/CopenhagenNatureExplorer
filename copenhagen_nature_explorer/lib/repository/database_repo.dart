import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseRepo {
  final String uid;
  DatabaseRepo({this.uid});

  final CollectionReference databaseRef =
      Firestore.instance.collection("users");

  Future createUserAccount(String displayName) async {
    return await databaseRef.document(uid).setData({
      "displayName": displayName,
    });
  }

  Future getUserDisplayName() async {
    String displayName;
    await databaseRef.document(uid).get().then((snapShot) {
      displayName = snapShot.data["displayName"].toString();
    });
    return displayName;
  }
}
