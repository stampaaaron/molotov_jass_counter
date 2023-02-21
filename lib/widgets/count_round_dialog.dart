import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/player.dart';
import '../utils/validation.dart';

class CountRoundDialog extends StatefulWidget {
  final List<Player> players;

  const CountRoundDialog({super.key, required this.players});

  @override
  State<CountRoundDialog> createState() => _CountRoundDialogState();
}

class _CountRoundDialogState extends State<CountRoundDialog> {
  final formKey = GlobalKey<FormState>();

  Map<Player, int?> points = {};

  get usedPoints => points.values.isEmpty
      ? 0
      : points.values.reduce((cur, prev) => (prev ?? 0) + (cur ?? 0));

  @override
  build(context) {
    return AlertDialog(
      title: const Text("Runde zählen"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("$usedPoints von 157 Punkten sind vergeben."),
            ...widget.players
                .map((player) => TextFormField(
                      autofocus: player == widget.players.first,
                      decoration: InputDecoration(labelText: player.username),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: notEmptyValidator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) => setState(
                          () => points[player] = int.tryParse(value) ?? 0),
                      onSaved: (value) {
                        if (value == null) return;
                        setState(
                            () => points[player] = int.tryParse(value) ?? 0);
                      },
                    ))
                .toList()
          ],
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
