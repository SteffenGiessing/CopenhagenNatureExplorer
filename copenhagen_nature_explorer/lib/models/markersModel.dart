import 'package:google_maps_flutter/google_maps_flutter.dart';
// Markers Model Class reated to help me create Nearest Station & Route Markers And all the paramters a marker need to be created.
class MarkerCreator {
  String infoText;
  double latitude;
  double longitude;
  String pictureUrl;
  String displayName;

  MarkerCreator({
    this.infoText,
    this.displayName,
    this.pictureUrl,
    this.latitude,
    this.longitude
  });
}

class RouteMarkers {

  Set<Marker> markersList;
  RouteMarkers({this.markersList});
}

class NearestStation {

  Map<String, LatLng> nearestStation;
  NearestStation({nearestStation});
}
