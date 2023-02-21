import 'package:flutter/material.dart';
import 'package:molotov_jass_counter/models/game.dart';
import 'package:molotov_jass_counter/models/player.dart';

class CurrentGameModel extends ChangeNotifier {
  Game? _currentGame;

  Game? get currentGame => _currentGame;
  set currentGame(Game? game) => _currentGame = game;

  addPointsFor(int points, Player player) {
    final rows = _currentGame?.rows;
    if (rows == null) return;

    if (rows.isEmpty || rows.last.isNewRound) {
      rows.add(GameRow(false));
    }

    rows.last.points[player] = (rows.last.points[player] ?? 0) + points;
    notifyListeners();
  }
}
