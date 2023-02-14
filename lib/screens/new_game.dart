import 'package:flutter/material.dart';
import 'package:molotov_jass_counter/models/player.dart';

import '../models/game.dart';

class NewGameScreen extends StatefulWidget {
  const NewGameScreen({super.key, required this.title});

  final String title;

  @override
  State<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  final _game = Game([
    Player('Hans'),
    Player(''),
    Player(''),
    Player(''),
  ]);

  _addPlayer() => setState(() {
        _game.players.add(Player(""));
      });

  _removePlayer(int index) => setState(() {
        _game.players.removeAt(index);
        print(_game.players.map((e) => e.username).toList());
      });

  @override
  build(context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
          padding: const EdgeInsets.all(12),
          child: Expanded(
            child: ListView(
              children: [
                Text(
                  "Endpunktzahl",
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 12),
                SegmentedButton(
                  selected: {_game.maxPoints},
                  segments: const [
                    ButtonSegment(value: 50, label: Text('50')),
                    ButtonSegment(value: 100, label: Text('100')),
                    ButtonSegment(value: 150, label: Text('150')),
                  ],
                  onSelectionChanged: (value) {
                    setState(() {
                      _game.maxPoints = value.first;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  "Mitspieler ${_game.players.length >= 8 ? '(max. 8)' : ''}",
                  style: theme.textTheme.labelLarge,
                ),
                for (var i = 0; i < _game.players.length; i++)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PlayerForm(index: i, player: _game.players[i]),
                      IconButton(
                          onPressed: _game.players.length > 3
                              ? () => _removePlayer(i)
                              : null,
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                    onPressed: _game.players.length < 8 ? _addPlayer : null,
                    icon: const Icon(Icons.add),
                    label: const Text("Hinzufügen"))
              ],
            ),
          )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: FilledButton(
          onPressed: () => print(_game.players.map((e) => e.username).toList()),
          style:
              ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          child: const Text("Starten"),
        ),
      ),
    );
  }
}

class PlayerForm extends StatefulWidget {
  final int index;
  final Player player;

  late final TextEditingController _usernameController;

  PlayerForm({super.key, required this.index, required this.player}) {
    _usernameController = TextEditingController(text: player.username);
  }

  @override
  createState() => _PlayerFormState();
}

class _PlayerFormState extends State<PlayerForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  build(context) {
    return Form(
        key: _formKey,
        child: Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Spieler ${widget.index + 1}',
            ),
            controller: widget._usernameController,
            onChanged: (value) => widget.player.username = value,
            onSaved: (value) => widget.player.username = value,
          ),
        ));
  }
}
