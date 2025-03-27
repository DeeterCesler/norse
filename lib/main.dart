import 'package:flutter/material.dart';
import 'package:norse_flashcards/pages/main_navigation_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Norse Runes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD2B48C), // Tan/beige color
          brightness: MediaQuery.platformBrightnessOf(context) == Brightness.dark
              ? Brightness.dark
              : Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationPage(),
    );
  }
}
