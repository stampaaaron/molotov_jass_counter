import 'package:flutter/material.dart';
import 'package:molotov_jass_counter/models/game.dart';

class CurrentGameModel extends ChangeNotifier {
  Game? _currentGame;

  Game? get currentGame => _currentGame;
  set currentGame(Game? game) => _currentGame = game;
}
