import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const SmartVillageApp());
}

class SmartVillageApp extends StatelessWidget {
  const SmartVillageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Village',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF16856B)),
        scaffoldBackgroundColor: const Color(0xFFF5F8F7),
      ),
      home: const HomeScreen(),
    );
  }
}
