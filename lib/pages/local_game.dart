import 'package:flutter/material.dart';
import 'package:tic_tac_shift/common/constants.dart';
import 'package:tic_tac_shift/services/sound_service.dart';

class LocalGame extends StatefulWidget {
  const LocalGame({super.key});

  @override
  State<LocalGame> createState() => _LocalGameState();
}

class _LocalGameState extends State<LocalGame> {
  List<String> board = List.filled(9, '');
  String currentTurn = 'X';
  int moveCount = 0;
  List<int> player1 = [0, 0, 0];
  List<int> player2 = [0, 0, 0];
  String boardState = '--------- 0 X';
  final player = SoundManager();
  String image =
      "https://plus.unsplash.com/premium_vector-1682269287900-d96e9a6c188b?q=80&w=1800&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Local Match"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PlayerInfo(
                  name: "Player1",
                  icon: image,
                  timeRemaining: 0,
                  isCurrentTurn: (currentTurn == "X"),
                ),
                PlayerInfo(
                  name: "Player2",
                  icon: image,
                  timeRemaining: 0,
                  isCurrentTurn: (currentTurn == "O"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: BoardWidget(
                  board: board,
                  onTileTap: (index) {
                    if (!_hasWon() && board[index] == '') {
                      setState(() {
                        _makeMove(index);
                      });
                      player.playClickSound();
                    }
                    if (_hasWon()) {
                      if (currentTurn == "O") {
                        showVictoryDialog(context, "Player1");
                      } else {
                        showVictoryDialog(context, "Player2");
                      }
                    }
                  },
                  lastThirdMoveX: getLastThirdMoves()['X']!,
                  lastThirdMoveO: getLastThirdMoves()['O']!,
                  moveCount: moveCount,
                ),
              ),
            )
          ],
        ),
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
      if (currentTurn == 'X') {
        if (moveCount >= 6) {
          board[player1[lastThirdMoveIndex]] = '';
        }
        player1[lastThirdMoveIndex] = index;
      } else if (currentTurn == 'O') {
        if (moveCount >= 6) {
          board[player2[lastThirdMoveIndex]] = '';
        }
        player2[lastThirdMoveIndex] = index;
      }
      board[index] = currentTurn;
      moveCount++;
      currentTurn = (currentTurn == 'X') ? 'O' : 'X';
    }
  }

  bool _hasWon() {
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
        "${board.map((cell) => cell.isEmpty ? "-" : cell).join('')} $moveCount $currentTurn";
  }

  List<String> stringToBoard(String boardState) {
    return boardState
        .substring(0, 9)
        .split('')
        .map((cell) => cell == '-' ? '' : cell)
        .toList();
  }

  Map<String, int> getLastThirdMoves() {
    int lastThirdMoveIndex = (moveCount ~/ 2) % 3;
    return {
      'X': player1[lastThirdMoveIndex],
      'O': player2[lastThirdMoveIndex],
    };
  }
}
