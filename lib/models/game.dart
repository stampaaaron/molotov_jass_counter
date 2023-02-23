import 'player.dart';

class Game {
  int maxPoints = 100;
  List<Player> players = [];
  late final List<GameRound> rounds = [];

  Map<Player, int> get totals => rounds.isNotEmpty
      ? rounds
          .map((round) => round.points.map((key, value) => MapEntry(
                key,
                (value.reducedCounted) +
                    (value.additional.isEmpty
                        ? 0
                        : value.reducedAdditional
                            .reduce((cur, prev) => cur + prev)),
              )))
          .reduce((prev, cur) => prev
              .map((key, value) => MapEntry(key, (value + (cur[key] ?? 0)))))
      : <Player, int>{};

  Game(this.players) {
    setupNewRound();
  }

  setupNewRound() {
    rounds.add(GameRound(Map.fromEntries(
        players.map((player) => MapEntry(player, PlayerPoints())))));
  }
}

class GameRound {
  Map<Player, PlayerPoints> points = {};

  GameRound(this.points);
}

class PlayerPoints {
  int? counted;
  List<int> additional = [];

  int get reducedCounted => ((counted ?? 0) / 10).round();
  List<int> get reducedAdditional =>
      additional.map((points) => (points / 10).round()).toList();

  PlayerPoints();
}
