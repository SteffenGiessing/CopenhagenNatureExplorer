import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;
  final List<String> transportTransit;
  final List<String> transportWalking;
  final String endAdress;

  const Directions({
    @required this.bounds,
    @required this.polylinePoints,
    @required this.totalDistance,
    @required this.totalDuration,
    @required this.endAdress,
    @required this.transportWalking,
    @required this.transportTransit,
  });

  factory Directions.fromMap(Map<String, dynamic> map, String mode) {
    if ((map["routes"] as List).isEmpty) return null;
    //Getting a step deeper inside Json object.
    final data = Map<String, dynamic>.from(map["routes"][0]);
    //Getting a step deeper inside Json object.
    final createData = Map<String, dynamic>.from(data["legs"][0]);

    //Setting Bounds
    final northeast = data["bounds"]["northeast"];
    final southwest = data["bounds"]["southwest"];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast["lat"], northeast["lng"]),
      southwest: LatLng(southwest["lat"], southwest["lng"]),
    );
    // String values to Store Total values.
    String distance = "";
    String duration = "";
    String endAdress = "";

    if ((data["legs"] as List).isNotEmpty) {
      //Total values
      final leg = data["legs"][0];
      distance = leg["distance"]["text"];
      duration = leg["duration"]["text"];
      endAdress = leg["end_address"];
    }
    // building List to return.
    List<String> transportTransit = [];
    List<String> transportWalking = [];

    Map<String, dynamic> getTransitDetails = new Map();

    // Values used when iterating through Json object.
    String exitStation;
    String shortName;
    String instructions;
    String walkingTime;
    String formattedInstructions;
    String walkingDistance;
    String totalTransitDistance;
    String totalTransitTime;

    var getNumber = createData["steps"];
    //If we are fetching a transit Json object from directions API
    //Runs through the json object and fetches the values from the json object that we need to build our rute dialog and adds it to our list
    if (mode == "transit") {
      final leg = data["legs"][0];
      totalTransitDistance = leg["distance"]["text"];
      totalTransitTime = leg["duration"]["text"];

      transportTransit.add(
          "Total Distance: $totalTransitDistance - Estimated Time: $totalTransitTime");
      for (int i = 0; i < getNumber.length; i++) {
        final createNext = Map<String, dynamic>.from(createData["steps"][i]);

        if (createNext.isEmpty) {
          break;
        } else {
          String getTravelMode = createNext["travel_mode"];

          if (getTravelMode == "WALKING") {
            transportTransit.add(createNext["html_instructions"]);
          } else if (getTravelMode == "TRANSIT") {
            instructions = createNext["html_instructions"];

            getTransitDetails =
                Map<String, dynamic>.from(createNext["transit_details"]);

            exitStation = getTransitDetails["arrival_stop"]["name"];
            shortName = getTransitDetails["line"]["short_name"];

            transportTransit.add("$instructions - Line: $shortName");
            transportTransit.add("Exit Station: $exitStation");
          }
        }
      }
      //If we are fetching a walking route from directions API
    } else {
      var getNumber = createData["steps"];
      walkingDistance = createData["distance"]["text"];
      walkingTime = createData["duration"]["text"];
      transportWalking.add(
          "Total Distance: $walkingDistance - Estimated Time: $walkingTime");
      for (int i = 0; i < getNumber.length; i++) {
        final createNext = Map<String, dynamic>.from(createData["steps"][i]);

        instructions = createNext["html_instructions"];
        // Formatting String to ensure that we dont get HTML values.
        formattedInstructions = instructions
            .replaceAll(RegExp("<b>"), " ")
            .replaceAll(RegExp("</b>"), " ")
            .replaceAll(RegExp("/<wbr/>"), " ")
            .replaceAll(RegExp('"'), " ")
            .replaceAll(RegExp("</div>"), " ")
            .replaceAll(RegExp("<div"), " ")
            .replaceAll("style= ", "")
            .replaceAll(RegExp("style=font-size:0.9em>"), " ")
            .replaceAll(RegExp("font-size:0.9em >"), " ");

        transportWalking.add(formattedInstructions);
      }
    }
    //Returns
    return Directions(
        bounds: bounds,
        polylinePoints: PolylinePoints()
            .decodePolyline(data["overview_polyline"]["points"]),
        totalDistance: distance,
        totalDuration: duration,
        endAdress: endAdress,
        transportWalking: transportWalking,
        transportTransit: transportTransit);
  }
}
