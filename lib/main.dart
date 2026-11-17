import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/menu.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// This widget is the root of the application.
  /// It configures the global [MaterialApp] settings, including the primary 
  /// routing destination and the overarching visual theme (colors, typography).
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPortofolio',
      theme: ThemeData(
        // This is the theme of your application.
        // The primary color is used for the app bar, buttons, and other elements.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066FF),
          secondary: Colors.amber[700],
        ).copyWith(
          primary: const Color(0xFF0066FF),   
          secondary: const Color(0xFF0066FF), 
        ),
        useMaterial3: true
      ),
      home: MyHomePage(),
    );
  }
}