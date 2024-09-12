import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:molotov_jass_counter/models/game.dart';

import '../models/player.dart';
import '../utils/validation.dart';

class CountRoundDialog extends StatefulWidget {
  final List<Player> players;
  final GameRound? round;

  const CountRoundDialog({super.key, required this.players, this.round});

  @override
  State<CountRoundDialog> createState() => _CountRoundDialogState();
}

class _CountRoundDialogState extends State<CountRoundDialog> {
  final formKey = GlobalKey<FormState>();

  Map<Player, int?> points = {};

  get usedPoints => points.isEmpty
      ? 0
      : points.values.map((e) => e ?? 0).reduce((cur, prev) => prev + cur);

  @override
  void initState() {
    if (widget.round != null) {
      points = widget.round!.points.map(
          (player, playerPoints) => MapEntry(player, playerPoints.counted));
    }
    super.initState();
  }

  @override
  build(context) {
    final theme = Theme.of(context);

    handleFillingLastField() {
      if (points.length < widget.players.length - 1 || widget.players.isEmpty) {
        return;
      }

      final playersNotCounted =
          widget.players.where((player) => !points.containsKey(player));

      if (playersNotCounted.length != 1) return;

      final pointsLeft = 157 - usedPoints;
      setState(() {
        points[playersNotCounted.first] =
            pointsLeft.isNegative ? 0 : pointsLeft.toInt();
      });
    }

    return AlertDialog(
      title: Text(widget.round == null ? "Runde zählen" : "Runde bearbeiten"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$usedPoints von 157",
                style: theme.textTheme.labelLarge,
              ),
              ...widget.players.map((player) => Focus(
                    child: TextFormField(
                      autofocus: player == widget.players.first,
                      decoration: InputDecoration(labelText: player.username),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: notEmptyValidator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        points[player] = int.tryParse(value) ?? 0;
                      },
                      onSaved: (value) {
                        setState(() {
                          if (value?.isEmpty ?? false) {
                            points.remove(player);
                          } else {
                            points[player] = int.tryParse(value!) ?? 0;
                          }
                        });
                      },
                      controller: TextEditingController(
                          text: (points[player] ?? '').toString()),
                    ),
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        formKey.currentState?.save();
                        handleFillingLastField();
                      }
                    },
                  ))
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            formKey.currentState?.validate();
            if (formKey.currentState?.validate() ?? false) {
              formKey.currentState?.save();
              Navigator.pop(context, points);
            }
          },
          child: const Text("Speichern"),
        )
      ],
    );
  }
}
