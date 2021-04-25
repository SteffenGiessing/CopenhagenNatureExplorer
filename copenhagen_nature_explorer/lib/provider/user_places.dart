import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../models/place.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class CreatedPlaces with ChangeNotifier {
  List<Place> _items = [];
  List<Place> get items {
    return [..._items];
  }

  void addPlace(
    String title,
    File image,
  ) async {
    final databaseRef = FirebaseDatabase.instance.reference();
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      description: title,
      location: null,
    );
    _items.add(newPlace);
    notifyListeners();

    var url = Uri.parse(
        "https://copenhagennatureexplorer-default-rtdb.europe-west1.firebasedatabase.app/");
    databaseRef
        .push()
        .set({"description": "new", "image": "Marianna", "location": "null"});

    databaseRef.once().then((DataSnapshot snapshot) {
      String newKey = snapshot.value.keys + [0];
      print(newKey);
    });

    http.post(
      url,
      body: {"description": "hej", "image": "image", "location": "null"},
    );
  }
}
