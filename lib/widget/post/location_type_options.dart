import 'package:flutter/material.dart';

/// Widget that let user decide show nearby post or select a location on map
class LocationTypeOptions extends StatelessWidget {
  final void Function(String) onClickOption;

  const LocationTypeOptions({@required this.onClickOption});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              onClickOption('nearby');
            },
            mini: true,
            backgroundColor: Colors.green,
            child: const Icon(Icons.near_me),
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              onClickOption('map');
            },
            mini: true,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.map)),
        ],
      ),
    );
  }
}
