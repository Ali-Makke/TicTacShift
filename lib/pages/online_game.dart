import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_shift/common/loading.dart';
import 'package:tic_tac_shift/services/database.dart';

import '../common/constants.dart';

class OnlineGame extends StatefulWidget {
  final String playerId;

  const OnlineGame({super.key, required this.playerId});

  @override
  State<OnlineGame> createState() => _OnlineGameState();
}

class _OnlineGameState extends State<OnlineGame> {
  final DatabaseService _dbService = DatabaseService();
  String? gameId;
  String? player1Id;
  String? player2Id;
  String? player1Letter;
  String? player2Letter;
  String? lastMovedPlayer;
  bool playersReady = false;

  @override
  void initState() {
    super.initState();
    _createOrJoinGame();
  }

  List<String> board = List.filled(9, '');
  String currentTurn = 'X';
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
          Text(widget.playerId),
          playersReady
              ? BoardWidget(
                  board: board,
                  currentPlayer: currentTurn,
                  onTileTap: (index) {
                    if (moveCount % 2 == 0 && player1Id == widget.playerId) {
                      if (!hasWon() && board[index] == '') {
                        setState(() {
                          _makeMove(index);
                        });
                      }
                    } else if (moveCount % 2 == 1 &&
                        player2Id == widget.playerId) {
                      if (!hasWon() && board[index] == '') {
                        setState(() {
                          _makeMove(index);
                        });
                      }
                    }
                  })
              : const Expanded(child: Loading()),
        ],
      ),
    );
  }

  void _makeMove(int index) async {
    updateBoard(index);
    boardToString(board);
    await _dbService.updateBoardState(
        gameId!, boardState, currentTurn, moveCount);
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
      currentTurn = (currentTurn == 'X') ? 'O' : 'X';
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

  void _createOrJoinGame() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Games')
        .where('status', isEqualTo: 'waiting')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      player2Id = widget.playerId;
      DocumentSnapshot gameSnapshot = querySnapshot.docs.first;
      gameId = gameSnapshot.id;
      await _dbService.updateGameWithPlayer2(gameId!, player2Id!);
      _listenToGameUpdates();
    } else {
      player1Id = widget.playerId;
      DocumentReference gameRef = await _dbService.createGame(player1Id!);
      gameId = gameRef.id;
      _listenToGameUpdates();
    }
  }

  void _listenToGameUpdates() {
    FirebaseFirestore.instance
        .collection('Games')
        .doc(gameId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          boardState = snapshot['boardState'];
          currentTurn = snapshot['currentTurn'];
          board = stringToBoard(boardState);
          moveCount = snapshot['moveCount'];
          player1Letter = snapshot['player1Letter'];
          player2Letter = snapshot['player2Letter'];
          player1Id = snapshot['player1Id'];
          player2Id = snapshot['player2Id'];
          if (!playersReady) {
            playersReady = (snapshot['status'] == 'ready');
          }
        });
      }
    });
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
}
