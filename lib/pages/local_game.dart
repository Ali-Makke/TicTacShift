import 'package:flutter/material.dart';
import 'package:tic_tac_shift/common/constants.dart';

class LocalGame extends StatefulWidget {
  const LocalGame({super.key});

  @override
  State<LocalGame> createState() => _LocalGameState();
}

class _LocalGameState extends State<LocalGame> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  int moveCount = 0;
  List<int> player1 = [0, 0, 0];
  List<int> player2 = [0, 0, 0];
  String boardState = '--------- 0 X';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Local Match"),
        centerTitle: true,
        backgroundColor: Colors.pink[400],
      ),
      body: Column(
        children: [
          Text(boardState),
          BoardWidget(
              board: board,
              currentPlayer: currentPlayer,
              onTileTap: (index) {
                if (!hasWon() && board[index] == '') {
                  setState(() {
                    _makeMove(index);
                  });
                }
              })
        ],
      ),
    );
  }

  void _makeMove(int index) {
    updateBoard(index);
    boardToString(board);
    board = stringToBoard(boardState);
  }

  void updateBoard(int index) {
    int lastThirdMoveIndex = (moveCount ~/ 2) % 3;
    if (board[index] == '') {
      if (currentPlayer == 'X') {
        if (moveCount >= 6) {
          board[player1[lastThirdMoveIndex]] = '';
        }
        player1[lastThirdMoveIndex] = index;
      } else if (currentPlayer == 'O') {
        if (moveCount >= 6) {
          board[player2[lastThirdMoveIndex]] = '';
        }
        player2[lastThirdMoveIndex] = index;
      }
      board[index] = currentPlayer;
      moveCount++;
      currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
    }
  }

  bool hasWon() {
    for (int i = 0; i < 3; i++) {
      if (board[i * 3] != '' &&
          board[i * 3] == board[i * 3 + 1] &&
          board[i * 3] == board[i * 3 + 2]) {
        return true;
      }
    }

    for (int i = 0; i < 3; i++) {
      if (board[i] != '' &&
          board[i] == board[i + 3] &&
          board[i] == board[i + 6]) {
        return true;
      }
    }

    if (board[0] != '' && board[0] == board[4] && board[0] == board[8]) {
      return true;
    }
    if (board[2] != '' && board[2] == board[4] && board[2] == board[6]) {
      return true;
    }
    return false;
  }

  void boardToString(List<String> board) {
    boardState =
        "${board.map((cell) => cell.isEmpty ? "-" : cell).join('')} $moveCount $currentPlayer";
  }

  List<String> stringToBoard(String boardState) {
    return boardState
        .substring(0, 9)
        .split('')
        .map((cell) => cell == '-' ? '' : cell)
        .toList();
  }
}
