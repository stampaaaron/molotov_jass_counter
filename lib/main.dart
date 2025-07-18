import 'package:flutter/material.dart';
import 'package:molotov_jass_counter/models/current_game.dart';
import 'package:molotov_jass_counter/models/game.dart';
import 'package:molotov_jass_counter/screens/game.dart';
import 'package:molotov_jass_counter/screens/new_game.dart';
import 'package:provider/provider.dart';

import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentGameModel(),
      child: MaterialApp(
        title: 'Molotow counter',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 171, 117, 0)),
            useMaterial3: true),
        routes: {
          '/': (context) => const HomeScreen(title: 'Molotow counter'),
          '/game/new': (context) => const NewGameScreen(title: 'Neues Spiel'),
          '/game': (context) => const GameScreen(title: 'Spiel'),
        },
      ),
    );
  }
}
