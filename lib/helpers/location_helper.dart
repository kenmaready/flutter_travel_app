import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Google maps API key from env file
String api_key = FlutterConfig.get('GOOGLE_MAPS_API_KEY') as String;

class LocationHelper {
  static String generateLocationPreviewImage(
      {double lat = 0.0, double long = 0.0}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$lat,$long&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=$api_key';
  }

  static Future<String> getPlaceAddress(
      {required double lat, required double long}) async {
    final url = Uri.https('https://maps.googleapis.com/maps/api/',
        '/geocode/json?latlng=$lat,$long&key=$api_key');

    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
