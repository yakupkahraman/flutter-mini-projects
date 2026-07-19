import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.grey[50],
            textTheme: TextTheme(
                displayLarge:
                    TextStyle(fontFamily: 'BebasNeue', color: Colors.grey[600]),
                headlineLarge: TextStyle(
                    fontFamily: 'BebasNeue', color: Colors.grey[600]))),
        darkTheme: ThemeData.dark().copyWith(
            textTheme: TextTheme(
                displayLarge:
                    TextStyle(fontFamily: 'BebasNeue', color: Colors.grey[400]),
                headlineLarge: TextStyle(
                    fontFamily: 'BebasNeue', color: Colors.grey[400]))),
        themeMode: ThemeMode.system,
        home: const HomePage());
  }
}
