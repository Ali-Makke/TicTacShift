import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../models/ai.dart';
import '../services/sound_service.dart';

class AiGamePage extends StatefulWidget {
  final Difficulty difficulty;

  const AiGamePage({super.key, required this.difficulty});

  @override
  State<AiGamePage> createState() => _AiGamePageState();
}

class _AiGamePageState extends State<AiGamePage> {
  AI? _ai;
  int moveCount = 0;
  String currentTurn = 'X';
  List<int> player1 = [0, 0, 0];
  List<int> player2 = [0, 0, 0];
  final player = SoundManager();
  String boardState = '--------- 0 X';
  List<String> board = List.filled(9, '');

  @override
  void initState() {
    super.initState();
    _ai = AI(widget.difficulty);
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
      body: (_ai!.difficulty == Difficulty.medium ||
              _ai!.difficulty == Difficulty.hard)
          ? Center(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const Column(children: [
                      Text(
                        "COMING SOON",
                        style: TextStyle(fontSize: 35),
                      )
                    ]);
                  }),
            )
          : Center(
              child: BoardWidget(
                board: board,
                onTileTap: (index) {
                  setState(() {
                    _makeMove(index);
                  });
                  player.playClickSound();
                  if (_hasWon()) {
                    if (currentTurn == "O") {
                      showVictoryDialog(context, "You");
                    } else {
                      showVictoryDialog(context, "AI");
                    }
                  }
                },
                lastThirdMoveX: getLastThirdMoves()['X']!,
                lastThirdMoveO: getLastThirdMoves()['O']!,
                moveCount: moveCount,
                size: 'Small',
              ),
            ),
    );
  }

  void _aiMove() {
    int move = _ai!.getMove(board);
    updateBoard(move);
  }

  void _makeMove(int index) {
    if (board[index] == '' && currentTurn == 'X') {
      updateBoard(index);
      boardToString(board);
      board = stringToBoard(boardState);
      if (!_hasWon()) {
        _aiMove();
      }
    }
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

  Map<String, int> getLastThirdMoves() {
    int lastThirdMoveIndex = (moveCount ~/ 2) % 3;
    return {
      'X': player1[lastThirdMoveIndex],
      'O': player2[lastThirdMoveIndex],
    };
  }
}
