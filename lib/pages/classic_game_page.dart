import 'package:flutter/material.dart';
import 'package:tic_tac_shift/common/constants.dart';
import 'package:tic_tac_shift/services/sound_service.dart';

class ClassicGamePage extends StatefulWidget {
  final String size;

  const ClassicGamePage({super.key, required this.size});

  @override
  State<ClassicGamePage> createState() => _ClassicGamePageState();
}

class _ClassicGamePageState extends State<ClassicGamePage> {
  List<String> board = [];
  String currentTurn = 'X';
  final player = SoundManager();
  String image =
      "https://plus.unsplash.com/premium_vector-1682269287900-d96e9a6c188b?q=80&w=1800&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";

  @override
  void initState() {
    board = (widget.size == "Small") ? List.filled(9, '') : List.filled(16, '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: sandText("Local Match"),
        centerTitle: true,
        foregroundColor: Colors.white,
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
                    if (!hasWon() && board[index] == '') {
                      setState(() {
                        _makeMove(index);
                      });
                      player.playClickSound();
                    }
                    if (_isDraw() && !hasWon()) {
                      showVictoryDialog(context, "Draw");
                    }
                    if (hasWon()) {
                      if (currentTurn == "O") {
                        showVictoryDialog(context, "Player1");
                      } else {
                        showVictoryDialog(context, "Player2");
                      }
                    }
                  },
                  lastThirdMoveX: 0,
                  lastThirdMoveO: 0,
                  moveCount: 0,
                  size: widget.size,
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
  }

  void updateBoard(int index) {
    if (board[index] == '') {
      board[index] = currentTurn;
      currentTurn = (currentTurn == 'X') ? 'O' : 'X';
    }
  }

  bool _isDraw() {
    if (board.contains('')) {
      return false;
    }
    return true;
  }

  bool hasWon() {
    if (widget.size == "Small") {
      return _hasWon3x3();
    }
    return _hasWon4x4();
  }

  bool _hasWon3x3() {
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

  bool _hasWon4x4() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 2; j++) {
        if (board[i * 4 + j] != '' &&
            board[i * 4 + j] == board[i * 4 + j + 1] &&
            board[i * 4 + j] == board[i * 4 + j + 2]) {
          return true;
        }
      }
    }

    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 2; j++) {
        if (board[j * 4 + i] != '' &&
            board[j * 4 + i] == board[(j + 1) * 4 + i] &&
            board[j * 4 + i] == board[(j + 2) * 4 + i]) {
          return true;
        }
      }
    }

    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        if (board[i * 4 + j] != '' &&
            board[i * 4 + j] == board[(i + 1) * 4 + j + 1] &&
            board[i * 4 + j] == board[(i + 2) * 4 + j + 2]) {
          return true;
        }
      }
    }

    for (int i = 0; i < 2; i++) {
      for (int j = 2; j < 4; j++) {
        if (board[i * 4 + j] != '' &&
            board[i * 4 + j] == board[(i + 1) * 4 + j - 1] &&
            board[i * 4 + j] == board[(i + 2) * 4 + j - 2]) {
          return true;
        }
      }
    }

    return false;
  }
}
