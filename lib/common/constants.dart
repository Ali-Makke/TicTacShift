import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/* file for shared code and styles */

const textInputDecoration = InputDecoration(
  hintText: "Email",
);

class PlayerInfo extends StatelessWidget {
  final String name;
  final String icon;
  final double timeRemaining;
  final bool isCurrentTurn;

  const PlayerInfo({
    super.key,
    required this.name,
    required this.icon,
    required this.timeRemaining,
    required this.isCurrentTurn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isCurrentTurn ? Colors.blue.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isCurrentTurn ? Colors.blue : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(icon),
            radius: 20,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCurrentTurn ? Colors.blue : Colors.black,
                ),
              ),
              Text(
                'Time Left: ${timeRemaining.round()}',
                style: TextStyle(
                  fontSize: 14,
                  color: isCurrentTurn ? Colors.blue : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BoardWidget extends StatelessWidget {
  final List<String> board;
  final Function(int) onTileTap;
  final int lastThirdMoveX;
  final int lastThirdMoveO;
  final int moveCount; // Add moveCount as an input

  const BoardWidget({
    super.key,
    required this.board,
    required this.onTileTap,
    required this.lastThirdMoveX,
    required this.lastThirdMoveO,
    required this.moveCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: GridView.count(
        crossAxisCount: 3,
        children: List.generate(9, (index) {
          Color tileColor = Colors.white;
          if (moveCount >= 6) {
            if (index == lastThirdMoveX) {
              tileColor = Colors.redAccent;
            } else if (index == lastThirdMoveO) {
              tileColor = Colors.blueAccent;
            }
          }
          return GestureDetector(
            onTap: () {
              onTileTap(index);
            },
            child: GridTile(
              child: Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: tileColor,
                ),
                child: Center(
                  child: Text(
                    board[index],
                    style: GoogleFonts.quicksand(fontSize: 45),
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

void showVictoryDialog(BuildContext context, String winnerName) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Congratulations!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Text(
          '$winnerName has won the match!',
          style: const TextStyle(fontSize: 18),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
