import 'dart:convert';
import 'package:http/http.dart' as http;

class Weatherservice {
  final String apikey = '40d9ccd672c8424694d185236242608';
  final String forecastbaseurl = 'http://api.weatherapi.com/v1/forecast.json';
  final String searchbaseurl = 'http://api.weatherapi.com/v1/search.json';
  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    final url = '$forecastbaseurl?key=$apikey&q=$city&days=1&aqi=no&alerts=no';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Faild to lead weather data');
    }
  }

  Future<Map<String, dynamic>> fetch7daysWeather(String city) async {
    final url = '$forecastbaseurl?key=$apikey&q=$city&days=7&aqi=no&alerts=no';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Faild to lead forecase data');
    }
  }

  Future<List<dynamic>?> fetchcitysujation(String query) async {
    final url = '$searchbaseurl?key=$apikey&q=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
