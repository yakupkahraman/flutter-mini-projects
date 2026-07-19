import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';

class WeatherService {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(double lat, double lon) async {
    final response = await http.get(
        Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<double>> getCurrentCity() async {
    //make sure location services are turned on
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services are disabled.');
    }

    //get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission was denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission is permanently denied. Enable it from system settings.',
      );
    }

    //fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    List<double> positions = [position.latitude, position.longitude];

    return positions;
  }
}
