import 'dart:convert';

import 'package:flutter/services.dart';

class CitiesHelper {
  Future<List> loadJson() async {
    String str = await rootBundle.loadString('assets/cities.json');
    List cities = jsonDecode(str);
    return cities;
  }
}

class City {
  String country;
  String name;
  double lat;
  double lng;
  City({this.country, this.name, this.lat, this.lng});
}
