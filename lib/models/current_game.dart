import 'package:flutter/material.dart';
import 'package:molotov_jass_counter/models/game.dart';
import 'package:molotov_jass_counter/models/player.dart';

class CurrentGameModel extends ChangeNotifier {
  Game? _currentGame;

  Game? get currentGame => _currentGame;

  set currentGame(Game? value) {
    _currentGame = value;
    notifyListeners();
  }

  void addPointsFor(int points, Player player) {
    currentGame?.rounds.last.points[player]?.additional.add(points);
    notifyListeners();
  }

  void addNewRound(Map<Player, int?> points) {
    points.forEach((key, value) {
      currentGame?.rounds.last.points[key]?.counted = value;
    });

    currentGame?.setupNewRound();

    notifyListeners();
  }

  void updateRound(int roundIndex, Map<Player, int?> points) {
    points.forEach((key, value) {
      currentGame?.rounds[roundIndex].points[key]?.counted = value;
    });

    notifyListeners();
  }

  void finishGame() {
    currentGame?.finished = true;
  }
}
