import 'package:flutter/material.dart';
import 'package:molotov_jass_counter/models/current_game.dart';
import 'package:molotov_jass_counter/widgets/simple_dialog_option_grid.dart';
import 'package:provider/provider.dart';

import '../models/player.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.title});

  final String title;

  @override
  createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  build(BuildContext context) {
    var theme = Theme.of(context);

    choosePlayer(List<Player> players) async {
      return await showDialog<Player>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(title: const Text('Weisen'), children: [
              SimpleDialogOptionGrid(
                  buildContent: (player) => Text('${player.username}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  options: players),
            ]);
          });
    }

    chooseAmountOfPoints() async {
      final pointOptions = [
        -20,
        20,
        -50,
        50,
        -70,
        70,
        -100,
        100,
        -150,
        150,
        -200,
        200
      ];

      return await showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(title: const Text('Weisen'), children: [
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
                  options: pointOptions),
            ]);
          });
    }

    return Consumer<CurrentGameModel>(
        builder: (context, value, child) => Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: Column(
                children: [
                  Table(
                    children: [
                      TableRow(
                          decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer),
                          children: value.currentGame?.players
                              .map((player) => TableCell(
                                      child: Text(
                                    player.username ?? '',
                                    style: theme.textTheme.labelLarge,
                                    textAlign: TextAlign.center,
                                  )))
                              .toList()),
                      TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            border: Border(
                                bottom: BorderSide(
                                    color: theme.colorScheme.primary)),
                          ),
                          children: value.currentGame?.totals.entries
                              .map((entry) => TableCell(
                                      child: Text(
                                    '${entry.value ?? ''}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )))
                              .toList()),
                      ...?value.currentGame?.rounds
                          .map((round) => TableRow(
                              children: round.entries
                                  .map((entry) => TableCell(
                                          child: Text(
                                        '${entry.value ?? ''}',
                                        textAlign: TextAlign.end,
                                      )))
                                  .toList()))
                          .toList()
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
                        var player =
                            await choosePlayer(value.currentGame!.players);
                        if (player != null) {
                          var points = await chooseAmountOfPoints();

                          final snackbar = SnackBar(
                            content: Text('${player.username} weist $points'),
                            duration: const Duration(seconds: 2),
                          );

                          if (points != null) {
                            value.addPointsFor(points, player);
                            scaffoldMessenger.showSnackBar(snackbar);
                          }
                        }
                      }
                    },
                    tooltip: 'Weisen',
                    child: Text(
                      '+/-',
                      style:
                          theme.textTheme.displaySmall!.copyWith(fontSize: 18),
                    ),
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: theme.colorScheme.onPrimary,
                    onPressed: () => null,
                    label: const Text('Zählen'),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ));
  }
}
