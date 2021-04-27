import 'package:flutter/foundation.dart';
import 'dart:io';

class LocationAttributes {
  final double latitude;
  final double longitude;
  final String address;

   const LocationAttributes({
    @required this.latitude,
    @required this.longitude,
    this.address,
  });
}

class Place {
  final String id;
  final LocationAttributes location;
  final String description;
  final File image;

   Place({
    @required this.id,
    @required this.description,
    @required this.location,
    @required this.image,
  });
}
