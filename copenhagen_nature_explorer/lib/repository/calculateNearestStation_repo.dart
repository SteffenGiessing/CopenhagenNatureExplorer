import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';

HttpsCallable callAble = FirebaseFunctions.instance.httpsCallable(
    "getNearestStation",
    options: HttpsCallableOptions(timeout: Duration(seconds: 5)));

Future trainstationCalcFunc(
    double currentMarkerLat, double currentMarkerLot) async {
  try {
    final HttpsCallableResult callGetNearest = await callAble.call(
      <String, double>{
        "latitude": currentMarkerLat,
        "longitude": currentMarkerLot,
      },
    );
    print(callGetNearest.data["response"]);
  } catch (e) {
    print(e);
  }
}
