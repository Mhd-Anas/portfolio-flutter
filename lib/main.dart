import 'package:flutter/material.dart';
import 'package:portfolio_web/pages/home_page.dart';
import 'package:portfolio_web/services/api_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
      ],
      child: const PortfolioApp(),
    ),
  );
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        textTheme: const TextTheme(
          // Updated to Material 3 style names
          displayLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
        ),
      ),
      home: const HomePage(),
    );
  }
}
