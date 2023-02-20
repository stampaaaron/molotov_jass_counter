import 'player.dart';

class Game {
  int maxPoints = 100;
  List<Player> players = [];
  late final List<Map<Player, int?>> rounds;

  Game(this.players) {
    rounds = [Game.setupRoundEntry(players)];
  }

  static setupRoundEntry(List<Player> players) =>
      Map.fromEntries(players.map((player) => (MapEntry(player, null))));
}
