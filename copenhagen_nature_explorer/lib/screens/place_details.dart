import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../model/place.dart';

class AddPlace with ChangeNotifier {
  List<Place> _items = [];
  List<Place> get items {
    return [..._items];
  }
}
