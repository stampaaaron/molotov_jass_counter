import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:molotov_jass_counter/models/current_game.dart';
import 'package:molotov_jass_counter/models/player.dart';
import 'package:provider/provider.dart';

import '../models/game.dart';

class NewGameScreen extends StatefulWidget {
  const NewGameScreen({super.key, required this.title});

  final String title;

  @override
  State<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  final _game = Game(List.generate(4, (index) => Player("")));

  List<PlayerForm> _getPlayerForms() => _game.players
      .map((player) => PlayerForm(
          index: _game.players.indexOf(player),
          player: player,
          onDelete: _removePlayer,
          amountOfPlayers: _game.players.length))
      .toList();

  _addPlayer() => setState(() => _game.players.add(Player("")));
  _removePlayer(int index) => setState(() {
        _game.players.removeAt(index);
        SchedulerBinding.instance.addPostFrameCallback((_) => validate());
      });

  final formKey = GlobalKey<FormState>();

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
                Form(
                  key: formKey,
                  child: Column(children: _getPlayerForms()),
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
          onPressed: () {
            if (validate()) {
              Navigator.pushNamed(context, "/game");
              Provider.of<CurrentGameModel>(context, listen: false)
                  .currentGame = _game;
            }
          },
          style:
              ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          child: const Text("Starten"),
        ),
      ),
    );
  }

  bool validate() {
    bool validate = formKey.currentState?.validate() ?? false;
    if (validate) formKey.currentState?.save();
    return validate;
  }
}

class PlayerForm extends StatefulWidget {
  final int index;
  final Player player;
  final Function onDelete;
  final int amountOfPlayers;

  late final TextEditingController _usernameController;

  PlayerForm(
      {super.key,
      required this.index,
      required this.player,
      required this.onDelete,
      required this.amountOfPlayers}) {
    _usernameController = TextEditingController(text: player.username);
  }

  @override
  State<StatefulWidget> createState() => _PlayerFormState();
}

class _PlayerFormState extends State<PlayerForm> {
  @override
  build(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Spieler ${widget.index + 1}',
            ),
            controller: widget._usernameController,
            onChanged: (value) => widget.player.username = value,
            onSaved: (value) => widget.player.username = value,
            validator: (value) => value == null || value.isEmpty
                ? 'Feld darf nicht leer sein.'
                : null,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
        IconButton(
            onPressed: widget.amountOfPlayers > 3
                ? () => widget.onDelete(widget.index)
                : null,
            icon: const Icon(Icons.delete))
      ],
    );
  }
}
