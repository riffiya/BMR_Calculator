import 'package:flutter/material.dart';
import 'package:bmr_calculator/pages/input_page.dart';
import 'package:bmr_calculator/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMR Calculator',
      theme: ThemeData(
        primaryColor: primaryBlue,
        scaffoldBackgroundColor: scaffoldGrey,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryBlue,
          centerTitle: true,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentBlue),
        textTheme: ThemeData.light().textTheme,
      ),
      home: const InputPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
