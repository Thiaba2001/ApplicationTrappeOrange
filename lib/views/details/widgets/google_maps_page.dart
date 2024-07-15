import 'package:http/http.dart' as http;
import 'dart:convert';

const GOOGLE_KEY_API = 'AIzaSyBebPcA35Q6WKIiGxG1Xi4iW0ZErazWvZA';

Uri _queryGetAddressFromLatLngBuilder(
    {required double lat, required double lng}) {
  return Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_KEY_API");
}

Future<String> getAddressFromLatLng(
    {required double lat, required double lng}) async {
  try {
    var response =
        await http.get(_queryGetAddressFromLatLngBuilder(lat: lat, lng: lng));
    if (response.statusCode == 200) {
      return json.decode(response.body)['results'][0]['formatted_address'];
    } else {
      throw 'Erreur !';
    }
  } catch (e) {
    rethrow;
  }
}
