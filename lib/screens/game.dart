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
              body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Table(
                      children: [
                        TableRow(
                            children: value.currentGame?.players
                                .map((player) => TableCell(
                                    child: Text(player.username ?? '')))
                                .toList())
                      ],
                    ),
                  ],
                ),
              ),
              floatingActionButton: Wrap(
                alignment: WrapAlignment.end,
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 20,
                children: [
                  FloatingActionButton.small(
                    onPressed: () async {
                      if (value.currentGame?.players != null) {
                        var player =
                            await choosePlayer(value.currentGame!.players);
                        if (player != null) {
                          var test = await chooseAmountOfPoints();
                          print(player.username);
                          print(test);
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
