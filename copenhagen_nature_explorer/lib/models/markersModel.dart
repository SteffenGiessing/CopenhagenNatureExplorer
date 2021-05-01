import 'package:flutter/foundation.dart';

class MarkerCreator {
  String infoText;
  double latitude;
  double longitude;
  String pictureUrl;
  String displayName;

  MarkerCreator({this.infoText, this.displayName, this.pictureUrl}) {
    print(pictureUrl);
    print(displayName);
    print(infoText);
  }
  String get getInfoText {
    return infoText;
  }

  String get getDisplayName {
    return displayName;
  }

  String get getPictureUrl {
    return pictureUrl;
  }
}
