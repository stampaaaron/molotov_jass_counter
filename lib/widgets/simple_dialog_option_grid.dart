import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class SimpleDialogOptionGrid<T> extends StatelessWidget {
  final List<T> options;
  final Widget Function(T option) buildContent;

  const SimpleDialogOptionGrid(
      {super.key, required this.buildContent, required this.options});

  @override
  build(context) {
    return LayoutGrid(
        columnSizes: [1.fr, 1.fr],
        rowSizes: List.generate((options.length / 2).floor(), (_) => auto),
        children: options
            .map((option) => SimpleDialogOption(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  onPressed: () {
                    Navigator.pop(context, option);
                  },
                  child: Center(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [buildContent(option)],
                  )),
                ))
            .toList());
  }
}
