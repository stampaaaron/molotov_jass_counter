import 'package:flutter/material.dart';
import 'package:molotov_jass_counter/models/game.dart';
import 'package:molotov_jass_counter/models/player.dart';

class CurrentGameModel extends ChangeNotifier {
  Game? currentGame;

  addPointsFor(int points, Player player) {
    final reducedPoints = (points / 10).floor();

    final rows = currentGame?.rows;
    if (rows == null) return;

    if (rows.isEmpty || rows.last.isNewRound) {
      rows.add(GameRow(false));
    }

    rows.last.points[player] = (rows.last.points[player] ?? 0) + reducedPoints;
    notifyListeners();
  }

  addNewRound(Map<Player, int?> points) {
    currentGame?.rows.add(GameRow(true, points: points));
    notifyListeners();
  }
}
