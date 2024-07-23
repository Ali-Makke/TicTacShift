import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_shift/common/loading.dart';
import 'package:tic_tac_shift/models/user_model.dart';
import 'package:tic_tac_shift/services/database.dart';

import '../common/constants.dart';

class OnlineGame extends StatefulWidget {
  final UserModel playerId;

  const OnlineGame({super.key, required this.playerId});

  @override
  State<OnlineGame> createState() => _OnlineGameState();
}

class _OnlineGameState extends State<OnlineGame> {
  Timer? _timer;
  String? gameId;
  String? username;
  int moveCount = 0;
  String? player1Id;
  String? player2Id;
  String? player1Letter;
  String? player2Letter;
  String currentTurn = 'X';
  bool playersReady = false;
  bool hasQuitMatch = false;
  List<int> player1 = [0, 0, 0];
  List<int> player2 = [0, 0, 0];
  int player1TimeRemaining = 300;
  int player2TimeRemaining = 300;
  String boardState = '--------- 0 X';
  List<String> board = List.filled(9, '');
  List<String> boardStates = ['--------- 0 X'];
  final DatabaseService _dbService = DatabaseService();
  StreamSubscription<DocumentSnapshot>? _gameSubscription;
  String image =
      "https://plus.unsplash.com/premium_vector-1682269287900-d96e9a6c188b?q=80&w=1800&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";

  @override
  void initState() {
    super.initState();
    _createOrJoinGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _gameSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Online Match"),
          centerTitle: true,
          backgroundColor: Colors.pink[400],
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () async {
                hasQuitMatch = true;
                await _dbService.updateBoardState(
                    gameId!,
                    boardState,
                    currentTurn,
                    moveCount,
                    player1TimeRemaining,
                    player2TimeRemaining,
                    hasQuitMatch);
                _timer?.cancel();
                _gameSubscription?.cancel();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_rounded)),
        ),
        body: playersReady
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PlayerInfo(
                          name: widget.playerId.email!.split("@")[0],
                          icon: image,
                          timeRemaining: player1TimeRemaining,
                          isCurrentTurn: (currentTurn == player1Letter),
                        ),
                        PlayerInfo(
                          name: "Player2",
                          icon: image,
                          timeRemaining: player2TimeRemaining,
                          isCurrentTurn: (currentTurn == player2Letter),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Center(
                        child: BoardWidget(
                          board: board,
                          currentPlayer: currentTurn,
                          onTileTap: (index) {
                            if (!_hasWon() && board[index] == '') {
                              if (player1Letter == currentTurn &&
                                  player1Id == widget.playerId.uid) {
                                setState(() {
                                  _makeMove(index);
                                });
                              } else if (player2Letter == currentTurn &&
                                  player2Id == widget.playerId.uid) {
                                setState(() {
                                  _makeMove(index);
                                });
                              }
                            }
                            if (_hasWon()) {
                              if (player2Letter == currentTurn) {
                                showVictoryDialog(context,
                                    widget.playerId.email!.split("@")[0]);
                              }
                              _timer?.cancel();
                              _gameSubscription?.cancel();
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ))
            : const Center(child: Loading()));
  }

  void _makeMove(int index) async {
    _updateBoard(index);
    _boardToString(board);
    //updates database board
    await _dbService.updateBoardState(gameId!, boardState, currentTurn,
        moveCount, player1TimeRemaining, player2TimeRemaining, hasQuitMatch);
    board = _stringToBoard(boardState);

    _startTimer();
  }

  //updates board pieces positions
  void _updateBoard(int index) {
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

  // converts list board to my notation
  void _boardToString(List<String> board) {
    boardState =
        "${board.map((cell) => cell.isEmpty ? "-" : cell).join('')} $moveCount $currentTurn";
  }

  //converts from my notation to list board to update the board
  List<String> _stringToBoard(String boardState) {
    return boardState
        .substring(0, 9)
        .split('')
        .map((cell) => cell == '-' ? '' : cell)
        .toList();
  }

  //join available game as player2 or create a new game if non was found
  void _createOrJoinGame() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Games')
        .where('status', isEqualTo: 'waiting')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      player2Id = widget.playerId.uid;
      DocumentSnapshot gameSnapshot = querySnapshot.docs.first;
      gameId = gameSnapshot.id;
      await _dbService.updateGameWithPlayer2(gameId!, player2Id!);
      _listenToGameUpdates();
    } else {
      player1Id = widget.playerId.uid;
      DocumentReference gameRef = await _dbService.createGame(player1Id!);
      gameId = gameRef.id;
      _listenToGameUpdates();
    }
  }

  //listen for data change then retrieves realtime updated data from database,
  void _listenToGameUpdates() {
    _gameSubscription = FirebaseFirestore.instance
        .collection('Games')
        .doc(gameId)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          if (!playersReady) {
            playersReady = (snapshot['status'] == 'ready');
          } else {
            _startTimer();
          }
          player1Id = snapshot['player1Id'];
          player2Id = snapshot['player2Id'];
          moveCount = snapshot['moveCount'];
          boardState = snapshot['boardState'];
          currentTurn = snapshot['currentTurn'];
          player1Letter = snapshot['player1Letter'];
          player2Letter = snapshot['player2Letter'];
          player1TimeRemaining = snapshot['player1TimeRemaining'];
          player2TimeRemaining = snapshot['player2TimeRemaining'];
          board = _stringToBoard(boardState);
        });
        // widget.player1.username = (await FirebaseFirestore.instance.collection("Users").doc("1234").get()).get('username');
      }
    });
  }

  //checks if game state is a winning state
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

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (currentTurn == player1Letter) {
          player1TimeRemaining--;
        } else {
          player2TimeRemaining--;
        }
      });

      if (player1TimeRemaining == 0 || player2TimeRemaining == 0) {
        _timer?.cancel();
      }
    });
  }
}
