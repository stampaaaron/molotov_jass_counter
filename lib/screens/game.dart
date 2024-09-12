import 'dart:math';

import 'package:flutter/material.dart';
import 'package:molotov_jass_counter/models/current_game.dart';
import 'package:molotov_jass_counter/models/game.dart';
import 'package:molotov_jass_counter/utils/config.dart';
import 'package:molotov_jass_counter/widgets/simple_dialog_option_grid.dart';
import 'package:provider/provider.dart';

import '../models/player.dart';
import '../widgets/count_round_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.title});

  final String title;

  @override
  createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  shouldContinueGame(List<Player> loosingPlayers) async {
    getText() {
      final looserNames = loosingPlayers.map((e) => e.username).toList();
      if (loosingPlayers.length < 2) {
        return Text("${looserNames[0]} hat das Spiel verloren");
      }

      if (loosingPlayers.length < 3) {
        return Text("${looserNames.join(" und ")} haben das Spiel verloren");
      }
      return Text(
          "${looserNames.getRange(0, looserNames.length - 1).join(", ")} und ${looserNames.last} haben das Spiel verloren");
    }

    return await showDialog<bool>(
      context: context,
      builder: (builder) => AlertDialog(
        title: const Text("Wollen Sie weiter spielen?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Beenden')),
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Weiter spielen')),
        ],
        content: getText(),
      ),
    );
  }

  @override
  build(BuildContext context) {
    var theme = Theme.of(context);

    choosePlayer(List<Player> players) async => await showDialog<Player>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Weisen'),
            children: [
              SimpleDialogOptionGrid(
                buildContent: (player) => Text(
                  '${player.username}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                options: players,
              ),
            ],
          ),
        );

    chooseAmountOfPoints() async {
      return await showDialog<int>(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Weisen'),
          children: [
            SimpleDialogOptionGrid(
              buildContent: (points) => Center(
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    points.isNegative ? Icons.remove : Icons.add,
                    size: 20,
                  ),
                  Text(
                    '${points.abs()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )),
              options: Config.possiblePoints,
            ),
          ],
        ),
      );
    }

    countRound(List<Player> players, GameRound? round) async =>
        await showDialog<Map<Player, int?>>(
          context: context,
          builder: (builder) => CountRoundDialog(
            players: players,
            round: round,
          ),
        );

    return Consumer<CurrentGameModel>(builder: (context, value, child) {
      if (value.currentGame == null) return Container();

      handleFinishGame() async {
        if (value.currentGame!.shouldFinish) {
          final shouldContinue =
              await shouldContinueGame(value.currentGame!.finishedPlayer!);
          value.finishGame();
          if (!shouldContinue && context.mounted) {
            Navigator.pushNamed(context, "/");
          }
        }
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Table(
              columnWidths: const {0: FixedColumnWidth(10)},
              children: [
                // Players row
                TableRow(
                  decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer),
                  children: [
                    TableCell(child: Container()),
                    ...?value.currentGame?.players.map((player) => TableCell(
                            child: Text(
                          player.username ?? '',
                          style: theme.textTheme.labelLarge,
                          textAlign: TextAlign.center,
                        )))
                  ],
                ),
                // Totals row
                TableRow(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      border: Border(
                          bottom: BorderSide(color: theme.colorScheme.primary)),
                    ),
                    children: [
                      TableCell(child: Container()),
                      ...?value.currentGame?.players.map((player) => TableCell(
                              child: Text(
                            '${value.currentGame?.totals[player] ?? 0}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )))
                    ]),
                // Rounds
                ...?value.currentGame?.rounds
                    .map((round) {
                      final additionalsRowCount = round.points.values
                          .map((e) => e.additional.length)
                          .reduce(max);

                      final roundIndex =
                          (value.currentGame?.rounds.indexOf(round) ?? 0);

                      return [
                        // Weise
                        for (int i = 0; i < additionalsRowCount; i++)
                          TableRow(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: theme.colorScheme
                                            .surfaceContainerHighest)),
                              ),
                              children: [
                                TableCell(child: Container()),
                                ...?value.currentGame?.players.map((player) {
                                  final additionalPoints =
                                      round.points[player]?.reducedAdditional ??
                                          [];
                                  return TableCell(
                                    child: Text(
                                      '${additionalPoints.length > i ? additionalPoints[i] : ''}',
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                })
                              ]),
                        // Counted values
                        if (round.points.values
                            .any((element) => element.counted != null))
                          TableRow(
                            decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                border: Border(
                                    bottom: BorderSide(
                                        color: theme.colorScheme.primary))),
                            children: [
                              TableCell(
                                  child: Text(
                                (roundIndex + 1).toString(),
                                style:
                                    TextStyle(color: theme.colorScheme.primary),
                              )),
                              ...?value.currentGame?.players.map((player) =>
                                  GestureDetector(
                                    onLongPress: () async {
                                      if (value.currentGame?.players != null) {
                                        final points = await countRound(
                                          value.currentGame!.players,
                                          round,
                                        );

                                        if (points == null) return;

                                        value.updateRound(roundIndex, points);
                                      }
                                    },
                                    child: TableCell(
                                        child: Text(
                                      '${round.points[player]?.reducedCounted ?? ''}',
                                      textAlign: TextAlign.center,
                                    )),
                                  )),
                            ],
                          )
                      ];
                    })
                    .toList()
                    .expand((element) => element)
              ],
            ),
          ],
        ),
        floatingActionButton: Wrap(
          alignment: WrapAlignment.end,
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 20,
          children: [
            FloatingActionButton.small(
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);

                if (value.currentGame?.players != null) {
                  var player = await choosePlayer(value.currentGame!.players);

                  if (player == null) return;

                  var points = await chooseAmountOfPoints();

                  if (points == null) return;

                  final snackbar = SnackBar(
                    content: Text('${player.username} weist $points'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "Rückgängig",
                      onPressed: () => value.addPointsFor(-1 * points, player),
                    ),
                  );

                  value.addPointsFor(points, player);
                  scaffoldMessenger.showSnackBar(snackbar);

                  handleFinishGame();
                }
              },
              tooltip: 'Weisen',
              child: Text(
                '+/-',
                style: theme.textTheme.displaySmall!.copyWith(fontSize: 18),
              ),
            ),
            FloatingActionButton.extended(
              backgroundColor: theme.primaryColor,
              foregroundColor: theme.colorScheme.onPrimary,
              onPressed: () async {
                if (value.currentGame?.players == null) return;

                var points = await countRound(value.currentGame!.players, null);

                if (points == null) return;

                value.addNewRound(points);

                handleFinishGame();
              },
              label: const Text('Zählen'),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      );
    });
  }
}
