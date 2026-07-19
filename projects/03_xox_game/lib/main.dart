import 'package:flutter/material.dart';
import '/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XoX',
      theme: ThemeData.dark(useMaterial3: true)
          .copyWith(scaffoldBackgroundColor: Color(0xff53607f)),
      home: const HomePage(),
    );
  }
}