import 'package:flutter/material.dart';
import 'package:tic_tac_shift/pages/ai_game_page.dart';

import '../common/constants.dart';
import '../models/ai.dart';

class AiDifficultyPage extends StatefulWidget {
  const AiDifficultyPage({super.key});

  @override
  State<AiDifficultyPage> createState() => _AiDifficultyPageState();
}

class _AiDifficultyPageState extends State<AiDifficultyPage> {
  Difficulty _selectedDifficulty = Difficulty.easy;

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiGamePage(difficulty: _selectedDifficulty),
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
            title: const Text('Easy'),
            leading: Radio(
              value: Difficulty.easy,
              groupValue: _selectedDifficulty,
              onChanged: (Difficulty? value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Medium'),
            leading: Radio(
              value: Difficulty.medium,
              groupValue: _selectedDifficulty,
              onChanged: (Difficulty? value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Hard'),
            leading: Radio(
              value: Difficulty.hard,
              groupValue: _selectedDifficulty,
              onChanged: (Difficulty? value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: _startGame,
            child: const Text('Start Game'),
          ),
        ],
      ),
    );
  }
}
