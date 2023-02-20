import 'package:flutter/material.dart';
import 'package:molotov_jass_counter/models/game.dart';
import 'package:molotov_jass_counter/models/player.dart';

class CurrentGameModel extends ChangeNotifier {
  Game? _currentGame;

  Game? get currentGame => _currentGame;
  set currentGame(Game? game) => _currentGame = game;

  addPointsFor(int points, Player player) {
    if (_currentGame == null) return;

    _currentGame!.rounds.add({player: points});
    notifyListeners();
  }
}
