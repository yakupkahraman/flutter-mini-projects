import '/pages/home_page.dart';
import 'package:flutter/material.dart';
import '/services/note_service.dart';
import 'package:provider/provider.dart';
import '/theme/theme_provider.dart';

void main() async {
  // Initialize the local database before the app starts.
  WidgetsFlutterBinding.ensureInitialized();
  await NoteService.initialize();

  runApp(
    MultiProvider(
      providers: [
        // Provides note data to the app.
        ChangeNotifierProvider(create: (context) => NoteService()),

        // Provides light and dark theme state.
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Notes App",
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const HomePage(),
    );
  }
}
