import 'package:flutter/material.dart';
import 'package:molotov_jass_counter/models/game.dart';
import 'package:molotov_jass_counter/models/player.dart';

class CurrentGameModel extends ChangeNotifier {
  Game? currentGame;

  addPointsFor(int points, Player player) {
    currentGame?.rounds.last.points[player]?.additional.add(points);
    notifyListeners();
  }

  addNewRound(Map<Player, int?> points) {
    points.forEach((key, value) {
      currentGame?.rounds.last.points[key]?.counted = value;
    });

    currentGame?.setupNewRound();

    notifyListeners();
  }

  finishGame() {
    currentGame?.finished = true;
  }
}
