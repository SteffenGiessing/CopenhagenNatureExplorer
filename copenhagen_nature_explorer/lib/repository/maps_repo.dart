const GOOGLE_API_KEY = 'AIzaSyBD0JNJvNmsLca-jBExQM2acpahTPQqHmI';
//{double latitude, double longitude}
class LocationFinder {
  static String generateLocation({double latitude, double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=Taastrup+DK&size=1200x1200&zoom=9&markers=color:blue%7Clabel:S%7C11211%7C11206%7C11222&key=$GOOGLE_API_KEY';
    //55.7303589,12.3612313
  }
}