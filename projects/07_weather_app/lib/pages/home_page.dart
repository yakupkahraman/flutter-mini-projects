import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //api key
  final _weatherService = WeatherService('YOUR API KEY');
  Weather? _weather;
  String? _errorMessage;

  //fetch weather
  Future<void> _fetchWeather() async {
    setState(() {
      _errorMessage = null;
    });

    try {
      //get the current city, then the weather for it
      final positions = await _weatherService.getCurrentCity();
      final weather =
          await _weatherService.getWeather(positions[0], positions[1]);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/clear.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'dust':
        return 'assets/cloud.json';
      case 'smoke':
      case 'mist':
      case 'haze':
      case 'fog':
        return 'assets/foggy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/clear.json';
      case 'snow':
        return 'assets/snow.json';
      default:
        return 'assets/clear.json';
    }
  }

  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Icon(
                  Icons.location_on,
                  size: 30,
                  color: Colors.grey[700],
                ),
                Text(
                  _errorMessage ?? _weather?.cityName ?? "loading city...",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
            if (_errorMessage == null) ...[
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              Text(
                '${_weather?.temperature.round()}°C',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
