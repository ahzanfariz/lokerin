import 'package:flutter/material.dart';
import 'package:sqflite_crud_flutter/home.dart';
import 'package:sqflite_crud_flutter/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LOKERIN',
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: StyleApp.primary,
            ),
        primaryColor: StyleApp.primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}
