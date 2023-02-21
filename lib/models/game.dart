import 'player.dart';

class Game {
  int maxPoints = 100;
  List<Player> players = [];
  late final List<GameRow> rows = [];

  Map<Player, int?> get totals => rows.isNotEmpty
      ? rows.map((round) => round.points).reduce((prev, cur) => prev
          .map((key, value) => MapEntry(key, (value ?? 0) + (cur[key] ?? 0))))
      : {};

  Game(this.players);
}

class GameRow {
  final bool isNewRound;
  final Map<Player, int?> points;

  GameRow(this.isNewRound, {this.points = const {}});
}
