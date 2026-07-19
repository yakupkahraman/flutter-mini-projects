# Weather App

🟡 **Intermediate** · A Flutter weather app. Data is taken from OpenWeatherMap.org.

On launch the app asks for location permission, finds your coordinates, fetches the
current weather, and shows the temperature with a Lottie animation matching the
conditions — rain, snow, fog, clear, and so on.

## 📸 Screenshots

<p align="center">
  <img src="../../docs/07_weather_app/cloud.png" width="240" alt="Cloud weather" />
</p>

## What You'll Learn

- How to build a weather app with Flutter
- How to fetch data from a REST API
- How to use geolocation to get the user's current position
- How to work with async network calls and JSON parsing
- How to display animated weather states with Lottie
- How to turn JSON into a Dart object with a `factory` constructor
- How to keep networking out of your widgets with a service class
- How to load data on startup from `initState`
- How to show loading and error states while data is in flight
- How to support light and dark mode with `ThemeMode.system`

## Project Structure

```
lib/
├── models/
│   └── weather.dart          # Weather + JSON parsing
├── pages/
│   └── home_page.dart        # UI, state, and animation picking
├── services/
│   └── weather_service.dart  # HTTP calls and location permissions
└── main.dart                 # Light/dark themes
assets/
├── clear.json  cloud.json  foggy.json     # Lottie animations
├── rain.json   snow.json   thunder.json
└── BebasNeue-Regular.ttf
```

## Key Concepts

### Parsing JSON with a factory constructor

The API returns a deeply nested JSON object. A `factory` constructor pulls out just
the three fields the app needs, so the rest of the code never touches raw maps:

```dart
class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}
```

### The network call

`units=metric` asks the API for Celsius. A non-`200` status means something went
wrong, so it throws rather than returning bad data:

```dart
Future<Weather> getWeather(double lat, double lon) async {
  final response = await http.get(
    Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric'),
  );

  if (response.statusCode == 200) {
    return Weather.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load weather data');
  }
}
```

### Handling location permission properly

Permission isn't a yes/no — there are several states, and each needs different
handling. "Denied forever" in particular can't be re-requested; the user has to
change it in system settings:

```dart
if (!await Geolocator.isLocationServiceEnabled()) {
  throw Exception('Location services are disabled.');
}

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
```

### Fetching on startup, and the three UI states

`initState` runs once when the screen is created — the right place to kick off a
one-time load. It can't be `async` itself, so it calls an `async` method:

```dart
@override
void initState() {
  super.initState();
  _fetchWeather();
}
```

Because the data arrives later, the UI has to handle **loading**, **loaded** and
**error** states. Null-aware operators cover the first two in a single line:

```dart
Text(_errorMessage ?? _weather?.cityName ?? "loading city...")
```

And the animation only shows when there's no error:

```dart
if (_errorMessage == null) ...[
  Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
  Text('${_weather?.temperature.round()}°C'),
],
```

### Mapping conditions to animations

The API's `main` condition is a string like `Rain` or `Clouds`. A `switch`
translates it to an asset, grouping similar conditions and always falling back to
something valid:

```dart
switch (mainCondition.toLowerCase()) {
  case 'clouds':
  case 'dust':
    return 'assets/cloud.json';
  case 'rain':
  case 'drizzle':
  case 'shower rain':
    return 'assets/rain.json';
  // ...
  default:
    return 'assets/clear.json';
}
```

## Official Package Docs

- [geolocator](https://pub.dev/packages/geolocator) for location access and permission handling
- [http](https://pub.dev/packages/http) for REST API requests
- [lottie](https://pub.dev/packages/lottie) for animated weather assets

## Getting Started

Prerequisites:

- Flutter SDK installed
- A free API key from [OpenWeatherMap](https://openweathermap.org/api)

Install dependencies:

```bash
flutter pub get
```

To add or regenerate platform support, run:

```bash
flutter create --platforms=android,ios,macos,windows,linux,web .
```

Add your API key:

- Open `lib/pages/home_page.dart` and replace `'YOUR API KEY'` with your OpenWeatherMap API key:

  ```dart
  final _weatherService = WeatherService('YOUR API KEY');
  ```

- The app also needs location permission to work. After running `flutter create` above, add location usage descriptions for the platforms you target (for example `NSLocationWhenInUseUsageDescription` in `ios/Runner/Info.plist`, or the `ACCESS_FINE_LOCATION` permission in `android/app/src/main/AndroidManifest.xml`) — see the [geolocator setup guide](https://pub.dev/packages/geolocator#setup) for the exact steps per platform.

> ⚠️ **Don't commit your API key.** It's hardcoded here to keep the example simple,
> but for anything real, pass it in at build time with
> `flutter run --dart-define=OWM_API_KEY=yourkey` and read it via
> `String.fromEnvironment('OWM_API_KEY')`.

Run the app:

```bash
flutter run
```

> Testing on a simulator? Location may need to be set manually — on the iOS
> Simulator use **Features → Location**, and on an Android emulator set it from the
> extended controls panel.

## Try It Yourself

- Add a pull-to-refresh gesture
- Let the user search for a city by name instead of using location
- Show a 5-day forecast using OpenWeatherMap's forecast endpoint
- Add a retry button when the request fails
