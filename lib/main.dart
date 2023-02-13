import 'package:flutter/material.dart';

import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Molotov counter',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const MyHomePage(title: 'Molotov counter'),
    );
  }
}
