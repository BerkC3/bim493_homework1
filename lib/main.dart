import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const CampusEventApp());
}

class CampusEventApp extends StatelessWidget {
  const CampusEventApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3949AB),
    );

    return MaterialApp(
      title: 'Campus Event Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: colorScheme.surfaceContainerLowest,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surfaceContainerLowest,
          centerTitle: false,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
