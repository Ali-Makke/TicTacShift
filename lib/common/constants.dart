import 'package:flutter/material.dart';

/* file for shared code and styles */

const textInputDecoration = InputDecoration(
  hintText: "Email",
);

class BoardWidget extends StatelessWidget {
  final List<String> board;
  final String currentPlayer;
  final Function(int) onTileTap;

  BoardWidget({
    required this.board,
    required this.currentPlayer,
    required this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        children: List.generate(9, (index) {
          return GestureDetector(
            onTap: () {
              onTileTap(index);
            },
            child: GridTile(
              child: Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    board[index],
                    style: const TextStyle(fontSize: 45),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
