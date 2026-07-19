import '/pages/home_page.dart';
import 'package:flutter/material.dart';
import '/theme/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Tracker',
      theme: darkTheme,
      darkTheme: darkTheme,
      home: const HomePage(),
    );
  }
}
