import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Directions {
  final List<PointLatLng> polylinePoints;
  final List<String> transportTransit;
  final List<String> transportWalking;

  const Directions({
    @required this.polylinePoints,
    @required this.transportWalking,
    @required this.transportTransit,
  });

  factory Directions.fromMap(Map<String, dynamic> map, String mode) {
    if ((map["routes"] as List).isEmpty) return null;
    //Getting a step deeper inside Json object.
    final data = Map<String, dynamic>.from(map["routes"][0]);
    //Getting a step deeper inside Json object.
    final createData = Map<String, dynamic>.from(data["legs"][0]);

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
    String totalTransitTime;

    //Get number of steps in JSON file to know how many iterations we have to do in the for loop.
    var getNumber = createData["steps"];

    //If we are fetching a transit Json object from directions API
    //Runs through the json object and fetches the values from the json object that we need to build our rute dialog and adds it to our list
    if (mode == "transit") {
      //Get Leg as it is first element in the json which gives me full duration.
      final leg = data["legs"][0];
      //Fetched duration time for transit route.
      totalTransitTime = leg["duration"]["text"];
      //Add values to list
      transportTransit.add(
          "Estimated Time: $totalTransitTime");
      //For each loop iterating over the JSON object.
      for (int i = 0; i < getNumber.length; i++) {
        //Step into the JSON object for each step and run through to fetch values.
        final createNext = Map<String, dynamic>.from(createData["steps"][i]);
        //Checking it is not empty
        if (createNext.isEmpty) {
          break;
        } else {
          //Get Travel mode
          String getTravelMode = createNext["travel_mode"];

          //Check if travelmode is walking. 
          //If travel mode is walking we will have to fetch values from it because lets say the tranist route says walk to this station.
          if (getTravelMode == "WALKING") {
            //Fetch instructions -> html instructions is the instructions like Walk to Nørreport.
            transportTransit.add(createNext["html_instructions"]);
            //See if transit
          } else if (getTravelMode == "TRANSIT") {
            //Fetching instructions for transit.
            instructions = createNext["html_instructions"];
            //Taking a step deeper into the Json object to fetch transit details.
            getTransitDetails =
                Map<String, dynamic>.from(createNext["transit_details"]);
            //Fetching arrival stop
            exitStation = getTransitDetails["arrival_stop"]["name"];
            //Fetching what line -> Like take F train.
            shortName = getTransitDetails["line"]["short_name"];
            //String interpolation for the two values.
            transportTransit.add("$instructions - Line: $shortName");
            //Strin interpolation for the exitStop
            transportTransit.add("Exit Station: $exitStation");
          }
        }
      }
      //If we are fetching a walking route from directions API
    } else {
      //Get number of steps in JSON file to know how many iterations we have to do in the for loop.
      var getNumber = createData["steps"];
      //Total walking distance.
      walkingDistance = createData["distance"]["text"];
      //Total time from station to destination Walking.
      walkingTime = createData["duration"]["text"];
      //String interpolation add values to list.
      transportWalking.add(
          "Total Distance: $walkingDistance - Estimated Time: $walkingTime");
      //For loop to iterate through each step
      for (int i = 0; i < getNumber.length; i++) {
        //Step inside step
        final createNext = Map<String, dynamic>.from(createData["steps"][i]);
        //Get intstructions.
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
        //Add to list
        transportWalking.add(formattedInstructions);
      }
    }
    //Returns
    return Directions(
        polylinePoints: PolylinePoints()
            .decodePolyline(data["overview_polyline"]["points"]),
        transportWalking: transportWalking,
        transportTransit: transportTransit);
  }
}
