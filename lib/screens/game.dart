import 'package:flutter/material.dart';
import 'package:molotov_jass_counter/models/current_game.dart';
import 'package:provider/provider.dart';

import '../models/player.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.title});

  final String title;

  @override
  createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  var players = <Player>[
    Player("Test"),
    Player("Test"),
    Player("Test"),
    Player("test"),
  ];

  @override
  build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Consumer<CurrentGameModel>(
          builder: (context, value, child) => Table(
            children: [
              TableRow(
                  children: value.currentGame?.players
                      .map((player) =>
                          TableCell(child: Text(player.username ?? '')))
                      .toList())
            ],
          ),
        ),
      ),
      floatingActionButton: Wrap(
        alignment: WrapAlignment.end,
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 20,
        children: [
          FloatingActionButton.small(
            onPressed: () => null,
            tooltip: 'Increment',
            child: Text(
              '+/-',
              style: theme.textTheme.displaySmall!.copyWith(fontSize: 18),
            ),
          ),
          FloatingActionButton.extended(
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.colorScheme.onPrimary,
            onPressed: () => null,
            tooltip: 'Increment',
            label: const Text('Zählen'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
