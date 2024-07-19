import 'package:flutter/material.dart';

class LocalGame extends StatefulWidget {
  const LocalGame({super.key});

  @override
  _LocalGameState createState() => _LocalGameState();
}

class _LocalGameState extends State<LocalGame> {
  List<String> board = List.filled(9, '-');
  String currentPlayer = 'X';
  int moveCount = 0;

  void updateBoard(int index) {
    if (board[index] == '-') {
      setState(() {
        board[index] = currentPlayer;
        moveCount++;
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
      });
    }
  }

  String boardToString() {
    return '${board.join('')} $currentPlayer $moveCount';
  }

  void stringToBoard(String notation) {
    List<String> parts = notation.split(' ');
    setState(() {
      board = parts[0].split('');
      currentPlayer = parts[1];
      moveCount = int.parse(parts[2]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(9, (index) {
                return GestureDetector(
                  onTap: () => updateBoard(index),
                  child: GridTile(
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          board[index],
                          style: const TextStyle(fontSize: 48.0),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Current Player: $currentPlayer'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Move Count: $moveCount'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                String notation = boardToString();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Board Notation: $notation')),
                );
              },
              child: const Text('Show Notation'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                stringToBoard("XO-XOXO-X O 5");
              },
              child: const Text('Load Notation'),
            ),
          ),
        ],
      ),
    );
  }
}