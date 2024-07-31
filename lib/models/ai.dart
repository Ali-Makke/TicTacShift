import 'dart:math';

enum Difficulty { easy, medium, hard }

class AI {
  Difficulty difficulty;

  AI(this.difficulty);

  int getMove(List<String> board) {
    switch (difficulty) {
      case Difficulty.easy:
        return _easyMove(board);
      case Difficulty.medium:
        return _mediumMove(board);
      case Difficulty.hard:
        return _hardMove(board);
    }
  }

  int _easyMove(List<String> board) {
    List<int> availableMoves = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        availableMoves.add(i);
      }
    }
    return availableMoves[Random().nextInt(availableMoves.length)];
  }

  int _mediumMove(List<String> board) {
    return 0;
  }

  int _hardMove(List<String> board) {
    return 1;
  }
}
