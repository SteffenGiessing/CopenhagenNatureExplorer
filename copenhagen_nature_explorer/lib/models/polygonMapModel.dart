import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

  Set<Polygon> polygonMap() {
    // ignore: deprecated_member_use
    List<LatLng> polygonCordinats = new List();
    polygonCordinats.add(LatLng(55.50800858787899, 12.640172797687912));
    polygonCordinats.add(LatLng(55.52433653086542, 12.843419868000412));
    polygonCordinats.add(LatLng(56.050165460787206, 12.651159125812912));
    polygonCordinats.add(LatLng(56.192552238039255, 12.299596625812912));
    polygonCordinats.add(LatLng(56.03789250931526, 11.851903754719162));
    polygonCordinats.add(LatLng(55.76844367599267, 11.755773383625412));
    polygonCordinats.add(LatLng(55.582595328478334, 11.781865912922287));
    polygonCordinats.add(LatLng(55.582595328478334, 11.781865912922287));
    polygonCordinats.add(LatLng(55.402101637563305, 11.873876410969162));
    polygonCordinats.add(LatLng(55.26462312215679, 12.02699835921135));
    polygonCordinats.add(LatLng(55.2333114533373, 12.443792182453537));
    polygonCordinats.add(LatLng(55.43951303319231, 12.574254828937912));
    polygonCordinats.add(LatLng(55.50270219979265, 12.651159125812912));

    Set<Polygon> polygonSet = new Set();
    polygonSet.add(Polygon(
        polygonId: PolygonId("Testing"),
        points: polygonCordinats,
        fillColor: (Color.fromARGB(0, 0, 0, 0)),
        strokeColor: Colors.lightGreen,
        strokeWidth: 1));

    return polygonSet;

}
