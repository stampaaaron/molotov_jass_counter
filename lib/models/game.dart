import 'player.dart';

class Game {
  int maxPoints = 100;
  List<Player> players = [];
  late final List<Map<Player, int?>> rounds = [];

  Map<Player, int?> get totals => rounds.isNotEmpty
      ? rounds.reduce((prev, cur) => prev
          .map((key, value) => MapEntry(key, (value ?? 0) + (cur[key] ?? 0))))
      : Map.fromEntries(players.map((player) => (MapEntry(player, 0))));

  Game(this.players);

  static setupRoundEntry(List<Player> players) =>
      Map.fromEntries(players.map((player) => (MapEntry(player, null))));
}
