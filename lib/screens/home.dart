import 'package:flutter/material.dart';
import 'package:molotov_jass_counter/models/current_game.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/jass-teppich.png"),
          fit: BoxFit.fitHeight,
        )),
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Wrap(
            direction: Axis.horizontal,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () => Navigator.pushNamed(context, '/game/new'),
                icon: const Icon(Icons.add),
                label: const Text("Neues Spiel"),
              ),
              Consumer<CurrentGameModel>(builder: (context, value, child) {
                if (value.currentGame == null) return Container();

                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/game'),
                  icon: const Icon(Icons.send),
                  label: const Text("Letztes Spiel weiterführen"),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
