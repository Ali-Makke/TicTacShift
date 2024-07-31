import 'package:flutter/material.dart';
import 'package:tic_tac_shift/pages/classic_game_page.dart';

import '../common/constants.dart';

class ChooseBoardSizePage extends StatefulWidget {
  const ChooseBoardSizePage({super.key});

  @override
  State<ChooseBoardSizePage> createState() => _ChooseBoardSizePageState();
}

class _ChooseBoardSizePageState extends State<ChooseBoardSizePage> {
  String _selectedSize = "Small";

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassicGamePage(size: _selectedSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: sandText('Play Against AI'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('3X3'),
            leading: Radio(
              value: "Small",
              groupValue: _selectedSize,
              onChanged: (value) {
                setState(() {
                  _selectedSize = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('4x4'),
            leading: Radio(
              value: "Big",
              groupValue: _selectedSize,
              onChanged: (value) {
                setState(() {
                  _selectedSize = value!;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: _startGame,
            child: sandText('Start Game'),
          ),
        ],
      ),
    );
  }
}
