import 'package:flutter/material.dart';
import 'package:molotov_jass_counter/screens/game.dart';
import 'package:molotov_jass_counter/screens/new_game.dart';

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
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 171, 117, 0)),
          useMaterial3: true),
      routes: {
        '/': (context) => HomeScreen(title: 'Molotov counter'),
        '/game/new': (context) => NewGameScreen(title: 'Neues Spiel'),
      },
    );
  }
}
